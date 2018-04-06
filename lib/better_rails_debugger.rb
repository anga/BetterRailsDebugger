require "better_rails_debugger/engine"
require "mongoid"
require "haml"
require "will_paginate_mongoid"
require "will_paginate-bootstrap4"
require "font-awesome-rails"
require "parser/all"

require "better_rails_debugger/config"
require "better_rails_debugger/analyzer"
require "better_rails_debugger/parser/all"
Haml.init_rails(binding)

module BetterRailsDebugger
  # Your code goes here...
end
