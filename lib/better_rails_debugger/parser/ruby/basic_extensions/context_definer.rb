module BetterRailsDebugger::Parser::Ruby
  module ProcessorExtension
    def get_full_context_name(node)
      if node.type.to_s == 'class'
        get_full_class_name node
      elsif node.type.to_s == 'module'
        module_t, _ = *node
        super_module, module_name = *module_t
        if super_module.present?
          "#{super_module.to_sexp_array[2]}::#{module_name}"
        else
          module_name
        end
      elsif node.type.to_s == 'const'
        pre, name = *node
        if pre.present?
          "#{get_full_context_name pre}::#{name}"
        else
          name.to_s
        end
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
      klass, superclass, _ = *node

      klass_name = klass.to_sexp_array[2].to_s

      # Base case
      return klass_name unless klass.to_sexp_array[1].present?
      "#{get_full_context_name(superclass)}::#{klass_name}"
    end

    def params_to_hash(node)
      args = *node
      args.map do |arg|
        type, value = arg.type, *arg
        if type == :optarg
          [type, value, arg.to_sexp_array[2]]
        else
          [type, value]
        end

      end
    end
  end
  Processor.include ProcessorExtension

  module ContextRunnerExtension

    def current_context
      _context = get 'context'
      if !_context
        _context = Hash.new
      end
      _context['current'] ||= []
    end

    def push_context(value)
      _context = get 'context'
      if !_context
        _context = Hash.new
      end
      _context['current'] ||= []
      _context['current'] << value

      set 'context', _context
    end

    def pop_context
      _context = get 'context'
      if !_context
        _context = Hash.new
        set 'context', _context
      end

      # get basic information
      _context['current'] ||= []
      _context['current'].pop
      set 'context', _context
    end
  end

  ContextRunner.include ContextRunnerExtension

  class ContextDefiner < Extension
    position 100
    def setup
      # Module
      processor.subscribe_signal :begin_module do
        full_name = processor.get_full_context_name(node)
        full_name.split('::').each do |name|
          push_context name
        end
      end

      processor.subscribe_signal :end_module do
        full_name = processor.get_full_context_name(node)
        full_name.split('::').size.times do
          pop_context
        end
      end

      # CLASS
      processor.subscribe_signal :begin_class do
        klass, superclass, _ = *node

        full_name = processor.get_full_context_name(klass)

        # get basic information
        before_context = (current_context || []).join('::')
        if full_name['::'].present?
          complete_current_context = "#{before_context}::#{full_name}"
        else
          complete_current_context = full_name
        end

        class_info = (get complete_current_context) || HashWithIndifferentAccess.new
        class_info[:type] = 'class'
        class_info[:full_type] = 'class'
        class_info[:location] = klass.loc

        # Detect superclass
        class_info[:superclass] = processor.get_full_context_name superclass
        full_name.split('::').each do |name|
          push_context name
        end
        set complete_current_context, class_info
      end

      processor.subscribe_signal :end_class do
        full_name = processor.get_full_context_name(node)
        full_name.split('::').size.times do
          pop_context
        end
      end

      # SELF CLASS(class << self; end)
      processor.subscribe_signal :begin_sclass do
        # get basic information
        before_context = current_context.join('::')
        # set current context and information about it
        push_context 'self'
        if before_context.present?
          complete_current_context = "#{before_context}::self"
        else
          complete_current_context = 'self'
        end
        class_info = (get complete_current_context) || HashWithIndifferentAccess.new
        class_info[:type] = 'class'
        class_info[:full_type] = 'sclass'
        class_info[:location] = node.loc

        set complete_current_context, class_info
      end

      processor.subscribe_signal :end_sclass do
        pop_context
      end

      # def
      processor.subscribe_signal :begin_def do
        name, args, _ = *node

        # Class or module method
        if current_context.present?
          method_context = current_context.join('::')
          info = (get method_context) || HashWithIndifferentAccess.new
          info[:methods] ||= HashWithIndifferentAccess.new
          info[:methods][name] ||= HashWithIndifferentAccess.new
          info[:methods][name][:location] = node.loc
          info[:methods][name][:arguments] = processor.params_to_hash(args)
        else # Global methods
          method_context = "##{name}"

          info = HashWithIndifferentAccess.new
          info[:location] = node.loc
          info[:arguments] = processor.params_to_hash(args)

          set method_context, info
        end
        # set current context and information about it
        push_context "##{name}"
      end

      processor.subscribe_signal :end_def do
        pop_context
      end

      # defs (def self.method_name)
      processor.subscribe_signal :begin_defs do
        _, name, _, args= *node

        # Class or module method
        if current_context.present?
          # Push the method inside self definition, this is MyClass::Self methods => []
          method_context = current_context.join('::') + '::self'
          info = (get method_context) || HashWithIndifferentAccess.new
          info[:methods] ||= HashWithIndifferentAccess.new
          info[:methods][name] ||= HashWithIndifferentAccess.new
          info[:methods][name][:location] = node.loc

          info[:methods][name][:arguments] = processor.params_to_hash(args)
        else # Global methods
          method_context = "##{name}"

          info = HashWithIndifferentAccess.new
          info[:location] = node.loc
          info[:arguments] = processor.params_to_hash(args)

          set method_context, info
        end
        # set current context and information about it
        push_context 'self'
        push_context "##{name}"
      end

      processor.subscribe_signal :end_defs do
        pop_context # method name
        pop_context # self
      end

      # block (like map, each lambda or any other block param)
      # Context format $block#<method name, like each, map or lambda>
      processor.subscribe_signal :begin_block do
        method, _, _ = *node
        push_context "$block##{method.to_sexp_array[2]}"
      end

      processor.subscribe_signal :end_block do
        pop_context
      end

      # lambda (TODO)
      processor.subscribe_signal :begin_lambda do
      end

      processor.subscribe_signal :end_lambda do
      end

      # while
      processor.subscribe_signal :begin_while do
        push_context '$while'
      end

      processor.subscribe_signal :end_while do
        pop_context
      end

      # until
      processor.subscribe_signal :begin_until do
        push_context '$until'
      end

      processor.subscribe_signal :end_until do
        pop_context
      end

      # for
      processor.subscribe_signal :begin_for do
        push_context '$for'
      end

      processor.subscribe_signal :end_for  do
        pop_context
      end

    end
  end
end