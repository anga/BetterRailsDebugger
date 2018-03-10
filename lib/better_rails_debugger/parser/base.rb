module BetterRailsDebugger::Parser
  class Base
    def initialize(path, options)
      @path, @options = path, options
    end

    def analise
      raise NotImplementedError
    end
  end
end