module BetterRailsDebugger
  class Configuration
    include Singleton

    attr_reader :mongoid_config_file

    def initialize
      Mongoid.logger.level = Logger::FATAL
    end

    # Set MongoID configuration file
    def mongoid_config_file=(file_path)
      raise LoadError.new "File #{file_path} not found" if !File.exist? file_path
      @mongoid_config_file = file_path
    end

    # Skip globally, the analysis of all classes added here
    def skip_classes=(list)
      return @skip_classes if @skip_classes
      raise ArgumentError.new "Expected Array, got #{list.class}" if !list.kind_of? Array
      raise ArgumentError.new "Array must contain classes and mondules names only" if list.any? {|a| !a.class.kind_of?(Class)}
      @skip_classes ||= list
    end

    def skip_classes
      @skip_classes || []
    end

    private

    def classes_to_skip
      @classes_to_skip ||= ruby_classes + skip_classes
    end

    def ruby_classes
      @ruby_classes ||= %w{

      }.map(&:constantize)
    end
  end

  def self.configure(&block)
    block.call Configuration.instance
  end
end