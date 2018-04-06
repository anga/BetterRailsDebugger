# How to implement your own ruby parser extension

Every ruby extension heritage from `BetterRailsDebugger::Parser::Ruby::Extension` and must have defined `setup` method 
like this:

```ruby
class MyExtension < BetterRailsDebugger::Parser::Ruby::Extension
  def setup
    # some setup here
  end
end
```

Also, you can set the position in the execution tree of the extension. For example, we want to use `context` information
provided by `ContextDefined`. `ContextDefiner` has a position of `100`, then, we for example, put our extension at position
`110` (just to leave some position before).

Once you have the position stabilised, the next step is to subscribe to parser signals into setup method, for example, 
we want to warning the user when he puts many fors, we can subscribe to the signal `:begin_for` as the example below:

> If you want to know more about signals, pleas read ZZZZZZZ

```ruby
class MyExtension < BetterRailsDebugger::Parser::Ruby::Extension
  positino 110
  
  def setup
    processor.subscribe_signal :begin_for do
      # current_context => ['MyModule', 'MyClass', '#method_name', '%for', '%for', '%while']
      # count amount of loops in the current context
      total_loops == current_context .count do |cxt|
        ctx == '%for' or ctx == '%while' or ctx == '%map'
      end
      if total_loops >= 3
        puts "WARNING at line #{node.loc.line}, you have #{total_loops} nested loops"
      end
    end
  end
end
```
