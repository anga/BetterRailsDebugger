require "better_rails_debugger/engine"
require "mongoid"
require "haml"
require "will_paginate_mongoid"
require "will_paginate-bootstrap4"
require "font-awesome-rails"

require "better_rails_debugger/config"
require "better_rails_debugger/analyzer"

Haml.init_rails(binding)

module BetterRailsDebugger
  # Your code goes here...
end
