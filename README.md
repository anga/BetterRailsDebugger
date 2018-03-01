# BetterRailsDebugger
Add a a couple of code analyzers that helps you to find where you are loosing performance or memory.

Remember that tack memory allocation and free it's really expensive and is going to affect the performance
in your env.

DON'T USE THIS GEM IN PRODUCTION UNLESS YOU ACCEPT TO LOOSE PERFORMANCE 

## Installation
Better Rails Debugger it's a rails engine and you need to mount it into an existing rails app.
To do this add this line to your application's Gemfile:

```ruby
gem 'better_rails_debugger'
```

And then execute:
```bash
$ bundle
```

## Configuration

1) Mount the engine in `routes.rb`:

```ruby
mount BetterRailsDebugger::Engine => "/debug"
```

2) Enable Sidkiq (or any other activejob backend) in `config/application.rb`:

```ruby
config.active_job.queue_adapter = :sidekiq
```

3) Start sidekiq
```bash
bundle exec sidekiq
```

3) Set MongoID database.yml file:

Create an initializer to configure like `config/initializers/better_ruby_debugger.rb`

```ruby
BetterRailsDebugger.configure do |c|
  c.mongoid_config_file = 'config/mongoid_memory.yml'
end
```

## Usage

Once everything installed and configured, you can go to [http://localhost:3000/debug](http://localhost:3000/debug)

![alt confiuration screen]()

The first step is create an analyse group
## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
