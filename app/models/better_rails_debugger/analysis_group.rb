module BetterRailsDebugger
  class AnalysisGroup
    include Mongoid::Document

    include ::Mongoid::Document
    include Mongoid::Timestamps

    before_save :generate_analise_paths

    field :name, type: String

    has_many :group_instances, class_name: "::BetterRailsDebugger::GroupInstance", inverse_of: :analysis_group, dependent: :delete_all

    # Settings

    ## Memory options
    field :collect_memory_information, type: Boolean, default: true    # Disable this, disable all memory tracking options
    field :analise_memory_in_code, type: Boolean, default: true
    field :analise_memory_in_gems, type: Boolean, default: false
    field :record_objects_in, type: String, default: ""
    field :times_to_run, type: Integer, default: 0                     # 0: Infinite
    field :analyze_repeated_instances, type: Boolean, default: true    # if false, Check the identifier and do run the analyzer if already exist one with the same identifier

    ## Code execution options
    field :generate_method_execution_history, type: Boolean, default: false
    field :calculate_execution_time_of_methods, type: Boolean, default: false

    # Internal use
    field :analise_paths, type: Array, default: []

    private
    def generate_analise_paths
      if analise_memory_in_gems
        analise_paths << /.*\/gems\/.*/
      end

      record_objects_in.to_s.split(/\n/).each do |line|
        line = line.strip
        # Check if file exist
        if File.exist? line
          if File.directory? line
            analise_paths << /#{line}.*/
          elsif File.file? line
            analise_paths << /#{line}$/
          end
        end
      end
    end
  end
end
