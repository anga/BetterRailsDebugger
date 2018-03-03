module BetterRailsDebugger
  class AnalysisRecorderJob < ApplicationJob
    queue_as :default

    def perform(recorded={})
      recorded = recorded.symbolize_keys
      if not recorded[:instance_id].present?
        Rails.logger.error "[BetterRailsDebugger AnalysisRecorderJob] intance_id not found. Skiping..."
        return
      end

      instance = GroupInstance.find recorded[:instance_id]
      if not instance.present?
        Rails.logger.error "[BetterRailsDebugger AnalysisRecorderJob] GroupInstance '#{recorded[:instance_id]}' not found. Skiping..."
        return
      end

      # Now, with the group present... we can start to work on it
      # group = instance.analysis_group

      allocations_per_file = Hash.new(0)
      memsize_per_file = Hash.new(0)
      instance.objects.all.each do |object|
        allocations_per_file[object.source_file] += 1
        memsize_per_file[object.source_file] += object.memsize
        start = (l = object.source_line - 4) >= 0 ? l : 0
        # TODO: Optimize this
        object.source_code =  IO.readlines(object.source_file)[start..(object.source_line + 4)].join("\n")
        object.save
      end
      instance.allocations_per_file = allocations_per_file.to_json
      instance.memsize_per_file = memsize_per_file.to_json
      instance.save

    end
  end
end
