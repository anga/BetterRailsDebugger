module BetterRailsDebugger::Parser::Ruby
  module ProcessorExtension
      def get_full_context_name(node)
      if node.type.to_s == 'class'
        get_full_class_name node
      elsif node.type.to_s == 'const'
        pre, name = *node
        "#{get_full_context_name pre}::#{name}"
        # send are superclass
      elsif node.type.to_s == 'send'
        n, name, extra = *node
        if extra
          "#{name}::#{get_full_context_name(extra)}"
        else
          name.to_s
        end
      elsif node.type.to_s == 'sym'
        name = *node
        name.first.to_s
      end
    end

    def get_full_class_name(node)
      klass, superclass, body = *node

      klass_name = klass.to_sexp_array[2].to_s

      # Base case
      return klass_name unless klass.to_sexp_array[1].present?
      "#{get_full_context_name(klass.to_sexp_array[1])}::#{klass_name}"
    end
  end
  Processor.include ProcessorExtension

  class ContextDefiner < Extension
    position 100
    def setup
      #[:on_module, :on_class, :on_sclass, :on_def, :on_defs, :on_block, :on_lambda, :on_while, :on_while_post, :on_until,
      # :on_until_post, :on_for, :on_resbody, :on_rescue, :on_ensure, :on_begin, :on_kwbegin]

      # CLASS
      processor.subscribe_signal :begin_class do
        klass, superclass, body = *node
        context = get 'context'
        if !context
          context = Hash.new
          set 'context', context
        end

        # get basic information
        before_context = (context['current'] ||= []).join('::')
        klass_name = klass.to_sexp_array[2].to_s
        # set current context and information about it
        context['current'] << klass_name
        if before_context.present?
          complete_current_context = "#{before_context}::#{klass_name}"
        else
          complete_current_context = klass_name
        end

        class_info = (get complete_current_context) || HashWithIndifferentAccess.new
        class_info[:type] = 'class'
        class_info[:full_type] = 'class'
        class_info[:location] = klass.loc

        # Detect superclass
        class_info[:superclass] = processor.get_full_context_name superclass

        set 'context', context
        set complete_current_context, class_info
      end

      processor.subscribe_signal :end_class do
        klass, superclass, body = *node
        context = get 'context'
        if !context
          context = Hash.new
          set 'context', context
        end

        # get basic information
        context['current'] ||= []
        context['current'].pop
        set 'context', context
      end

      processor.subscribe_signal :end_class do
        klass, superclass, body = *node
        context = get 'context'
        if !context
          context = Hash.new
          set 'context', context
        end

        # get basic information
        context['current'] ||= []
        context['current'].pop
        set 'context', context
      end

      # SELF CLASS class << self; end
      processor.subscribe_signal :begin_sclass do
        context = get 'context'
        if !context
          context = Hash.new
          set 'context', context
        end

        # get basic information
        before_context = context['current'].join('::')
        # set current context and information about it
        context['current'] << 'self'
        if before_context.present?
          complete_current_context = "#{before_context}::self"
        else
          complete_current_context = 'self'
        end
        class_info = (get complete_current_context) || HashWithIndifferentAccess.new
        class_info[:type] = 'class'
        class_info[:full_type] = 'sclass'
        class_info[:location] = node.loc

        set 'context', context
        set complete_current_context, class_info
      end

      processor.subscribe_signal :end_sclass do
        klass, superclass, body = *node
        context = get 'context'
        if !context
          context = Hash.new
          set 'context', context
        end

        # get basic information
        context['current'] ||= []
        context['current'].pop
        set 'context', context
      end

      # def
      processor.subscribe_signal :begin_def do
        name, args, body = *node
        context = get 'context'
        if !context
          context = Hash.new
          set 'context', context
        end

        # get basic information

        # Class or module method
        if context['current']
          method_context = context['current'].join('::')
          info = (get method_context) || HashWithIndifferentAccess.new
          info[:methods] ||= HashWithIndifferentAccess.new
          info[:methods][name] ||= HashWithIndifferentAccess.new
          info[:methods][name][:location] = node.loc
        else # Global methods
          method_context = "##{name}"

          info = HashWithIndifferentAccess.new
          info[:location] = node.loc

          set method_context, info
        end
        # set current context and information about it
        context['current'] ||= []
        context['current'] << "##{name}"
        set 'context', context

        # Now, parse and set params information
      end


    end
  end
end