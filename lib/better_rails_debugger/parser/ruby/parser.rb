require 'parser/current'
module BetterRailsDebugger::Parser::Ruby
  class Parser < BetterRailsDebugger::Parser::Base
    def analise
      # Use some setting to select ruby version
      @node_tree = ::Parser::CurrentRuby.parse(File.read(@path)).to_a
      # Context store the current node tree
      @context = []
      @status = ParserStatus.new
      analise_node_tree
    end

    def analise_node_tree

    end
  end
end