# Public methods

## current_context

Returns an array where every element is a new context. The list of context defined are:

* <Module or class name>
* #<mehod_name>
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

