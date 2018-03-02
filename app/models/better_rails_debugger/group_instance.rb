module BetterRailsDebugger
  class GroupInstance
    include ::Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :analysis_group, class_name: "::BetterRailsDebugger::AnalysisGroup"
    has_many :objects, class_name: "::BetterRailsDebugger::ObjectInformation", inverse_of: :group_instance, dependent: :delete_all

    # Basic information
    field :identifier, type: String
    field :metadata, type: Hash

    # Status information
    field :processed, type: Boolean
    field :total_classes, type: Integer                 # Total number of used Classes
    field :total_memory, type: Integer                  # Total memory used in bytes
    field :total_files, type: Integer                   # Total file used on allocation
    field :allocations_per_file, type: Hash             # Hash with `file => num_allocations`
    field :inverse_allocation_per_file, type: Hash      # Hash with `allocations => Array<files>`

    # Internal use
    field :caller_file, type: String

    def track_allocation_of?(path)
      return true if match_file_list?(path) or called_from_caller_file?(path)
      false
    end

    private
    def match_file_list?(path)
      analysis_group.analise_paths.any? do |regexp|
        regexp.match?(path)
      end
    end

    def called_from_caller_file?(path)
      return false if !analysis_group.analise_memory_in_code
      return true if analysis_group.analise_memory_in_code and /#{caller_file}/.match?(path)
      false
    end
  end
end
