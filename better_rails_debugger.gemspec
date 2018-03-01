$:.push File.expand_path("../lib", __FILE__)

require "better_rails_debugger/version"

Gem::Specification.new do |s|
  s.name        = "better_rails_debugger"
  s.version     = BetterRailsDebugger::VERSION
  s.authors     = ["Andres Jose Borek"]
  s.email       = ["andres.b.dev@gmail.com"]
  s.homepage    = ""
  s.summary     = "Tool that helps you to debug memory issues and others."
  s.description = "Better rails debugger can analyze memory issues only by the moment, but performance is planned."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = '>= 2.4'


  s.add_dependency "rails", ["~> 5.1.5", "< 6.0"]
  s.add_dependency "haml-rails", ["~> 1.0", "< 2.0"]
  s.add_dependency "mongoid", [">= 7.0.0.beta", "< 8.0"]
  s.add_dependency "will_paginate_mongoid"
  s.add_dependency "will_paginate-bootstrap4"
  s.add_dependency "rouge", "~> 3.1"
  s.add_dependency "font-awesome-rails"

  s.add_development_dependency "sqlite3"
end
