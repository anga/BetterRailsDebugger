module BetterRailsDebugger::Parser::Ruby
  class Processor < ::Parser::AST::Processor
    attr_reader :information
    def initialize
      @information = ActiveSupport::HashWithIndifferentAccess.new
    end
    # Call all subscriptions for the given signal
    # @param signal_name Symbol
    # @param args Hash
    def emit_signal(signal_name, node)
      @subscriptions ||= Hash.new()
      @runner ||= BetterRailsDebugger::Parser::Ruby::ContextRunner.new self
      (@subscriptions[signal_name] || {}).values.each do |block|
        @runner.node = node
        @runner.instance_eval &block
        # block.call(node)
      end
    end

    # Subscribe to a particular signal
    # @param signal_name Symbol
    # @param step Symbol May be :first_pass or :second_pass
    # @param block Proc
    def subscribe_signal(signal_name, step=:first_pass, &block)
      key = SecureRandom.hex(5)
      @subscriptions ||= Hash.new()
      @subscriptions[signal_name] ||= Hash.new
      @subscriptions[signal_name][key] = block
      key
    end

    def unsubscribe(signal_name, hash)
      @subscriptions ||= Hash.new()
      @subscriptions[signal_name] ||= Hash.new
      @subscriptions[signal_name].delete hash
    end

    def cleanup_subscriptions
      @subscriptions = Hash.new()
    end

    def setup
      (@extensions = ::BetterRailsDebugger::Parser::Ruby::Extension.sorted_extensions).map do |klass|
        instance = klass.new self
        instance.setup
        instance
      end
    end

    # ON Methods
    #https://github.com/whitequark/parser/blob/7d72eba571b8684ff452dd9c1885ea8c43698442/lib/parser/ast/processor.rb

    [:on_dstr, :on_dsym, :on_regexp, :on_xstr, :on_splat, :on_array, :on_pair, :on_hash, :on_irange, :on_erange, :on_var,
     :on_lvar, :on_ivar, :on_gvar, :on_cvar, :on_back_ref, :on_nth_ref, :on_vasgn, :on_lvasgn, :on_ivasgn, :on_gvasgn,
     :on_cvasgn, :on_and_asgn, :on_or_asgn, :on_op_asgn, :on_mlhs, :on_masgn, :on_const, :on_casgn, :on_args, :on_argument,
     :on_arg, :on_optarg, :on_restarg, :on_blockarg, :on_shadowarg, :on_kwarg, :on_kwoptarg, :on_kwrestarg, :on_procarg0,
     :on_arg_expr, :on_restarg_expr, :on_blockarg_expr, :on_block_pass, :on_undef, :on_alias, :on_send, :on_csend,
     :on_index, :on_indexasgn, :on_return, :on_break, :on_next, :on_redo, :on_retry, :on_super, :on_yield, :on_defined?,
     :on_not, :on_and, :on_or, :on_if, :on_when, :on_case, :on_iflipflop, :on_eflipflop, :on_match_current_line,
     :on_match_with_lvasgn, :on_preexe, :on_postexe
    ].each do |method|
      define_method method do |node|
        emit_signal method.to_s.gsub('on_', '').to_sym, node
        emit_signal :all, node
        super node
      end
    end

    # signals where the node contains body, like methods, classes or modules
    [:on_module, :on_class, :on_sclass, :on_def, :on_defs, :on_block, :on_lambda, :on_while, :on_while_post, :on_until,
    :on_until_post, :on_for, :on_resbody, :on_rescue, :on_ensure, :on_begin, :on_kwbegin].each do |method|
      define_method method do |node|
        emit_signal "begin_#{method.to_s.gsub('on_', '')}".to_sym, node
        emit_signal :begin_all, node
        result = super node
        emit_signal "end_#{method.to_s.gsub('on_', '')}".to_sym, node
        emit_signal :end_all, node
        result
      end
    end
  end
end