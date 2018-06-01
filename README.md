# BetterRailsDebugger
> NOTE ABOUT NEW BACKTRACE FEATURE ON 0.2: Backtrace feature is in a really heavy development and **contains** bugs
> you can use it as a general reference. Get a backtrace of an already allocated object it's not simple (or
> is not for me :P). I hope you understand. With love, Angaroshi <3

> DISCLAIMER: This gem is in a really early development stage, you can start to use it, but
> do not expect a lot of features. Right now, the only supported feature it's track Ruby objects creations. 

> The gem is not abandoned, I'm waiting Rails to fix an issue with webpacker that does not allow me to continue with next
> features for this gem.

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

2) Enable Sidkiq (or any other activejob backend) in `config/application.rb` (remember you need to install `sidekiq` first):

```ruby
config.active_job.queue_adapter = :sidekiq
```

3) Start sidekiq
```bash
bundle exec sidekiq
```

3) Set MongoID database.yml file:

In rails 5 run:
```ruby
rails g mongoid:config
```

change the file configuration and/or rename it.

Create an initializer to configure like `config/initializers/better_ruby_debugger.rb`

```ruby
BetterRailsDebugger.configure do |c|
  c.mongoid_config_file = 'config/mongoid_memory.yml'
end
```

## Usage

Once everything installed and configured, you can go to [http://localhost:3000/debug](http://localhost:3000/debug)

<p align="center">
  <img src="https://raw.githubusercontent.com/anga/BetterRailsDebugger/master/doc/images/analysis_group.png">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/anga/BetterRailsDebugger/master/doc/images/new_analysis_group.png">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/anga/BetterRailsDebugger/master/doc/images/analysis_group_2.png">
</p>

Once you have the id of the group, you can start analysing code, for example, we are going to analyze all our rails 
controller actions:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :do_analysis

  def do_analysis
    BetterRailsDebugger::Analyzer.instance.analyze "#{request.url}", "5a98a93f50f04b079458fd57" do
      yield
    end
  end
end
```

With this, we can just go to our app, run the code and start to see some results:

<p align="center">
  <img src="https://raw.githubusercontent.com/anga/BetterRailsDebugger/master/doc/images/group_instance.png">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/anga/BetterRailsDebugger/master/doc/images/show_group_instance.png">
</p>

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
