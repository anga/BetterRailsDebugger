module BetterRailsDebugger::Parser::Ruby
  class ContextRunner
    attr_accessor :node, :processor
    def initialize(_processor)
      @processor = _processor
    end

    def set(key, value)
      @processor.information[key] = value
    end

    def get(key)
      @processor.information[key]
    end
  end
end