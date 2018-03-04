module BetterRailsDebugger
  class GroupInstance
    include ::Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :analysis_group, class_name: "::BetterRailsDebugger::AnalysisGroup"
    has_many :objects, class_name: "::BetterRailsDebugger::ObjectInformation", inverse_of: :group_instance, dependent: :delete_all
    has_many :trace_point_items, class_name: "::BetterRailsDebugger::TracePointItem", inverse_of: :group_instance, dependent: :delete_all

    # Basic information
    field :identifier, type: String
    field :metadata, type: Hash

    # Status information
    field :status, type: String
    field :total_classes, type: Integer                 # Total number of used Classes
    field :total_memory, type: Integer                  # Total memory used in bytes
    field :total_files, type: Integer                   # Total file used on allocation

    # Internal use
    field :caller_file, type: String
    field :allocations_per_file, type: String
    field :memsize_per_file, type: String

    ## Memory methods

    def memsize_per_file_hash
      return @memsize_per_file_hash if @memsize_per_file_hash.present?
      @memsize_per_file_hash = JSON.parse(memsize_per_file.to_s) rescue {}
    end

    def allocations_per_file_hash
      return @allocations_per_file if @allocations_per_file.present?
      @allocations_per_file = JSON.parse(allocations_per_file.to_s) rescue {}
    end

    def files_that_use_more_memory(n)
      memsize_per_file_hash.to_a.sort_by do |a| a[1] end.reverse[0..n]
    end

    def files_with_more_allocations(n)
      allocations_per_file_hash.to_a.sort_by do |a| a[1] end.reverse[0..n]
    end

    def count_methods
      return @count_methods if @count_methods
      @count_methods = Hash.new
      trace_point_items.each do |item|
        @count_methods["#{item.source_file}:#{item.source_line}"] ||= {
          item: item,
          count: 0
        }
        @count_methods["#{item.source_file}:#{item.source_line}"][:count] += 1
      end
      @count_methods
    end

    def most_used_methods(n)
      count_methods.to_a.sort_by do |a| a[1][:count] end.reverse[0..n].to_h
    end

    # Return an array of hash file => mem that consume more than 10 MB(default) or ram aprox
    # TODO: The amount of consumed ram must be configurable
    def big_files(max_size=10.megabytes)
      return @big_files if @big_files
      @big_files = (memsize_per_file_hash || {}).select do |key, size|
        size >= max_size
      end
    end

    # Return an array of hashed that contains some information about the classes that consume more than `max_size` bytess
    def big_classes(max_size=1.megabytes)
      return @big_classes if @big_classes
      @big_classes = {}
      ObjectInformation.where(:group_instance_id => self.id, :memsize.gt => max_size).all.each do |object|
        @big_classes[object.class_name] ||= {total_mem: 0, average: 0, count: 0}
        @big_classes[object.class_name][:total_mem] += object.memsize
        @big_classes[object.class_name][:count] += 1
      end
      @big_classes.each_pair do |klass, hash|
        @big_classes[klass][:average] = @big_classes[klass][:total_mem] / @big_classes[klass][:count]
      end
      @big_classes
    end

    ## Trace point methods

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
