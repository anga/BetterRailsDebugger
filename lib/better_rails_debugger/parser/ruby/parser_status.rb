module BetterRailsDebugger::Parser::Ruby
  class ParserStatus
    attr_accessor :status
    def initialize
      @status = ActiveSupport::HashWithIndifferentAccess.new
    end

    def set(name, value)
      @status[name] = value
    end

    def get(name)
      @status[name]
    end

    def []=(name,value)
      @status[name] = value
    end

    def [](name)
      @status[name]
    end
  end
end