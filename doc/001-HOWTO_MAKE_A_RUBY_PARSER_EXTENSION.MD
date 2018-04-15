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

All extension are executed sequentially. This give us some issues, what happens if we need to use the information that
another extension stored?. To force the _when_ an extension is going to be executed, you can use `position`. For example,
if we need to use `ContextDefiner` extension, we need to set the position of our extension after the position of this extension, 
that is 100. For example, we can set the position of our extension to be `110`, this way, there is some space before our extension
if someone depends wants to be executed just before and after `ContextDefiner`, just like this:

```ruby
class MyExtension < BetterRailsDebugger::Parser::Ruby::Extension
  position 110
  
  def setup
    # ...
  end
end
```

Once you have the position stabilised, the next step is to subscribe to parser signals into setup method, for example, 
we want to warning the user when he puts many fors, we can subscribe to the signal `:begin_for` as the example below:

> If you want to know more about signals, pleas read ZZZZZZZ

```ruby
class MyExtension < BetterRailsDebugger::Parser::Ruby::Extension
  position 110
  
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

> Next step, read CONTEXT_DEFINER.MD.