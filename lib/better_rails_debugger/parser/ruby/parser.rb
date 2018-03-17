require 'parser/current'
module BetterRailsDebugger::Parser::Ruby
  class Parser < BetterRailsDebugger::Parser::Base
    def analise
      # Use some setting to select ruby version
      @node_tree = ::Parser::CurrentRuby.parse(File.read(@path)).to_sexp_array
      @status = ParserStatus.new
      @klasses = Extension.sorted_extensions
      analise_node_tree(@node_tree)
    end

    def analise_node_tree(tree)
      add_context
      tree.each do |node_item|
        if node_item.kind_of? Array
          analise_node_tree node_item
        else
          push_to_context node_item
          @klasses.each do |klass|
            klass.run node_item, @status
          end
        end
      end
    end
  end
end