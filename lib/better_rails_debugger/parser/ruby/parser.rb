require 'parser/current'
module BetterRailsDebugger::Parser::Ruby
  class Parser < BetterRailsDebugger::Parser::Base
    def analise
      @node_tree = ::Parser::CurrentRuby.parse(File.read(@path)).to_a
      analise_node_tree
    end

    def analise_node_tree
    end
  end
end