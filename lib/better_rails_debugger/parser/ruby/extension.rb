module BetterRailsDebugger::Parser::Ruby
  class Extension
    @@classes = Hash.new(ActiveSupport::HashWithIndifferentAccess.new)
    # Define the position of the extension. The position define when should be executed, if for example we have Ext1 and
    # Ext2, with position 2 and 1, then Ext2 it's going to be executed before Ext1. This is useful for an extension that
    # depends of another one
    def self.position(position)
      # TODO: Allow to set position before another extension of after that one
      raise ArgumentError.new "Expected Integer or Float" unless position.kind_of? Integer or position.kind_of? Float
      @@classes[self.class][:position] = position
    end

    # Define the name of the extension.
    def self.name(extension_name)
      raise ArgumentError.new "Argument must define to_s method" unless position.respond_to? :to_s
      @@classes[self.class][:position] = position.to_s
    end

    def self.sorted_extensions
      @@classes.to_a.sort_by do |_, config|
        config[:position]
      end.map do |array|
        array[0]
      end
    end

    def initialize(status)
      @status = status
    end

    def run()
      raise ScriptError.new "Please, define run method"
    end
  end
end