# Public methods

## current_context

Returns an array where every element is a new context. The list of context defined are:

* Module or class name
* \#method_name
* $block#<method like map, each, lambda, etc> $for, $while, $until

Full example looks like

`['MyModule', 'ClassName', '#method', '$block#each', 'while']`


## get and set

If you want, for example, know what `ClassName` is, you can use `get` method to fetch information about something, in this
case

```ruby
  object_information = get 'MyModule::ClassName'
  puts object_information[:type] # 'class'
  puts object_information[:methods] # '#method_name' => {location: Parser::Source::Map::Definition}
```

and then, you can use `set` method to store some information and then be used by other extension or by yourself leather on.

```ruby
set 'something', {value: true}
```
# Information about classes and modules

Every class or module contains the next data


* method: Hash with #method_nem +> Hash<with extra information like :location>
* type: may be 'class' or 'module'

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

If, for example, you want to get the information about `Foo` class, you need to do:
```ruby
foo_information = get 'Test::MyModule::Fafa::Foo'
```