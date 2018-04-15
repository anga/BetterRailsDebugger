# Signals

Signals are one of the most important concepts for extensions. They allow to execute some code in a particular moment, 
for example we can subscribe to a method definition, a variable assignment, block usage and many many more events.

To do it, you need to run the method `subscribe_signal(event_name_symbol, &block)` from `processor`. The block must accept
one parameter that is the node information:

```ruby
processor.subscribe_signal :begin_method do |node|
  method, params, body = *node
  puts "Method name: #{method}"
end
```

# `*node`: Disassembling node information

> `node` is an `Parser::AST::Node` class and you can find more information about this [here](http://www.rubydoc.info/github/whitequark/parser/Parser/AST/Node).

`*node` split the information about the node and what does returns, depends of which node it is, you may debug each time to see what does returns.

# List of signals

There are 2 kind of signals, `one time singal` and `context signals`. The first one are signals that are mono-line, like 
variable assignment and the second one are those that are multi-line, like class definition, method definition and so on.

## One time signal

* :on_dstr
* :on_dsym
* :on_regexp
* :xstr
* :splat
* :array
* :pair
* :hash
* :irange
* :erange
* :var
* :lvar
* :ivar
* :gvar
* :cvar
* :back_ref
* :nth_ref
* :vasgn
* :lvasgn
* :ivasgn
* :gvasgn
* :cvasgn
* :and_asgn
* :or_asgn
* :op_asgn
* :mlhs
* :masgn
* :const
* :casgn
* :args
* :argument
* :arg
* :optarg
* :restarg
* :blockarg
* :shadowarg
* :kwarg
* :kwoptarg
* :kwrestarg
* :procarg0
* :arg_expr
* :restarg_expr
* :blockarg_expr
* :block_pass
* :undef
* :alias
* :send
* :csend
* :index
* :indexasgn
* :return
* :break
* :next
* :redo
* :retry
* :super
* :yield
* :defined?
* :not
* :and
* :or
* :if
* :when
* :case
* :iflipflop
* :eflipflop
* :match_current_line
* :_match_with_lvasgn
* :preexe
* :postexe

## Context signals

Every context block of code has 2 signals, the `:begin_CONTEXT` and `:end_CONTEXT`. Here we are going to list them as `:CONTEXT`
for simplicity, but remember that the real signal is `:begin_CONTEXT` and `:enc_CONTEXT`:

* :module
* :class
* :sclass
* :def
* :defs
* :block
* :lambda
* :while
* :while_post
* :until
* :until_post
* :for
* :resbody
* :rescue
* :ensure
* :begin
* :kwbegin

Then, for example, you can subscribe to `:begin_module` and `:end_module`

All signals are the same as `Parser::AST::Processor` [here](https://github.com/whitequark/parser/blob/master/lib/parser/ast/processor.rb)
without `on_`. You can read about them in `parser` gem.