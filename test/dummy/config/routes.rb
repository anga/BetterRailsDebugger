Rails.application.routes.draw do
  mount BetterRailsDebugger::Engine => "/better_rails_debugger"
end
