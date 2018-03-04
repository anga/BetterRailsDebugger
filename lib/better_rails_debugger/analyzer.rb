require 'objspace'

module BetterRailsDebugger
  class MemoryAnalyzer
    include Singleton


    def analyze(identifier, group_id)
      begin
        group = ::BetterRailsDebugger::AnalysisGroup.find group_id
      rescue Mongoid::Errors::DocumentNotFound
        # If the group does not exist, just run the code and return
        yield
        return
      end
      # If we reached the max time to execute the code, just execute the code and do not collect information
      if times_to_run_exceeded?(group) or skip_instance?(group, identifier)
        yield
      else
        ::ObjectSpace.trace_object_allocations do
          yield
        end
        collect_information(identifier, group_id)
      end
    end

    # Clean ObjectSpace abject allocation tracer history
    def clear_tracking
      ::ObjectSpace.trace_object_allocations_clear
    end

    def times_to_run_exceeded?(group)
      group.times_to_run.to_i > 0 and group.group_instances.count >= group.times_to_run
    end

    def skip_instance?(group, identifier)
      !group.analyze_repeated_instances and GroupInstance.where(identifier: identifier, analysis_group: group.id).count > 0
    end

    # Record into db, information about object creation
    def collect_information(identifier, group_id)
      group = ::BetterRailsDebugger::AnalysisGroup.find group_id
      if not group.present?
        Rails.logger.error "[BetterRailsDebugger] Group '#{recorded[:group_id]}' not found. Skiping..."
        return
      end

      # Load Mongo db if required
      if not Mongoid::Config.configured?
        Mongoid.load!(BetterRailsDebugger::Configuration.instance.mongoid_config_file, Rails.env.to_sym)
        Mongoid.logger.level = Logger::FATAL
      end

      instance = ::BetterRailsDebugger::GroupInstance.create identifier: identifier, analysis_group_id: group_id, caller_file: caller[3][/[^:]+/]

      collect_memory_information(instance)

      # Now, it's time to analyze all collected data and generate a report
      ::BetterRailsDebugger::AnalysisRecorderJob.perform_later({ instance_id: instance.id.to_s })
    end

    private

    def collect_memory_information(instance)
      objects = []
      return if !instance.analysis_group.collect_memory_information
      ObjectSpace.each_object(Object) do |obj|

        next if !all_valid_classes[obj.class]

        source_line = ObjectSpace.allocation_sourcefile(obj)

        # Do not track objects that we don't know where comes from
        next if !source_line

        next if !instance.track_allocation_of? source_line

        meta = {
          ruby_object_id: obj.object_id,
          source_file: source_line,
          source_line: ObjectSpace.allocation_sourceline(obj),
          memsize: ObjectSpace.memsize_of(obj),
          class_name: obj.class.name,
          group_instance_id: instance.id
        }

        # Add extra conditional metadata here....

        objects << meta
      end
      ::BetterRailsDebugger::ObjectInformation.collection.insert_many(objects)
    end

    def all_valid_classes
      return @all_valid_classes if @all_valid_classes
      if !@all_classes
        @all_classes = []
        ObjectSpace.each_object(Class) do |klass|
          @all_classes << klass
        end
      end
      @all_valid_classes = Hash.new false
      (@all_classes - ::BetterRailsDebugger::Configuration.instance.send(:classes_to_skip)).each do |klass|
        @all_valid_classes[klass] = true
      end
      @all_valid_classes
    end
  end
end