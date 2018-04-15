# ContextDefiner

This extension is part of BetterRailsDebugger Core and is one of the most basic but powerful tool that help other developer
to develop more extensions. His job is give to the user, the current context, where the code is located, like, inside a module,
 a class, a method or inside an iterator like `each` an also, record the basic information about those modules and classes,
 like location and methods defined.

## `current_context`: Getting the whole scope name

This is the main method that this extension gives you. This method returns an array where every element is a new context. 
The list of context defined are:

* Module or class name
* \#method_name
* $block#<method like map, each, lambda, etc> 
* $for, $while, $until

Full example looks like

`['MyModule', 'ClassName', '#method', '$block#each', '$while']`


## `get` and `set`: Adding more information

With the information provided by this extension is not going to be enough for you. You may need to store some information
somewhere to use it leather on. To to this, you can store information (generally as `Hash` object) using the method `set(context_name_string, value_to_store)`.
For example:

```ruby
set 'my_variable', 1
```

Then to get the value of `'my_variable'` you just use the method `get(context_name_string)`. For example

```ruby
value = get 'my_variable'
puts value # 1
```

This last method is useful when you want to get some information about some class or module. Suppose you need to get
information about `ClassName`, that is part of `MyModule` module, you can do this:

```ruby
  object_information = get 'MyModule::ClassName'
  puts object_information[:type] # 'class'
  puts object_information[:methods] # '#method_name' => {location: Parser::Source::Map::Definition}
```

Here you may noted that there is some useful information, like what is that constant, It's a class (`'class'`) or a module (`'module')? 
Which methods are defined there?

# Information about classes and modules

Every class or module contains the next data


* method: Hash with #method_nem +> Hash<with extra information like :location>
* type: may be `'class'` or `'module'`

# How does context looks like?

For this code:
```ruby
module Test::MyModule
  class Fafa::Foo < Something:Else::String

    class << self
    end

    def bar(one, two=2, &block)
      # do something
    end

    def self.my_method
    end

  end
end
```

```ruby
{
  "context"=>{"current"=>[]},
  "Test::MyModule::Fafa::Foo"=> {
    "type"=>"class",
    "full_type"=>"class",
    "location"=> Parser::Source::Map,
    "superclass"=>"Something::Else::String",
    "methods"=>{
      "bar"=>{
        "location"=> Parser::Source::Map,
        "arguments"=> [[:arg, :one], [:optarg, :two, [:int, 2]], [:blockarg, :block]]
      }
    }
  },
 "Test::MyModule::Fafa::Foo::self"=> {
    "type"=>"class",
    "full_type"=>"sclass",
    "location"=> Parser::Source::Map,
    "methods"=>{
      "my_method"=> {
        "location"=> Parser::Source::Map,
        "arguments"=>[]
      }
    }
  }
}
```

Here you may noted that all static methods are not inside `'Test::MyModule::Fafa::Foo'` context, are inside `'Test::MyModule::Fafa::Foo::self'` 

If, for example, you want to get the information about `Foo` class, you need to do:

```ruby
foo_information = get 'Test::MyModule::Fafa::Foo'
```