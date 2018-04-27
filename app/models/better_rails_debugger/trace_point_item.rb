module BetterRailsDebugger
  class TracePointItem
    include Mongoid::Document

    belongs_to :group_instance, class_name: "::BetterRailsDebugger::GroupInstance"

    field :source_file, type: String
    field :source_line, type: Integer
    field :method_id, type: String
    field :event, type: String

    def to_s
      "#{source_file}:#{source_line}"
    end

    def self.backtraces_for(group_instance_id, file, line)

      backtraces = []
      last_source = ::BetterRailsDebugger::TracePointItem.where(group_instance_id: group_instance_id).first
      current_backtrace = []
      current_backtrace_sources = []
      ::BetterRailsDebugger::TracePointItem.where(group_instance_id: group_instance_id).to_a[1..-1].each do |bkt|
        if bkt.source_file == file and bkt.source_line == line
          backtraces.push current_backtrace.dup.concat([[file, line, bkt.method_id]])
        # When we detect that we change the file and is not a method return (back to an old source file)
        elsif bkt.event.to_s == 'call'
          current_backtrace.push([last_source.source_file, last_source.source_line, last_source.method_id])
          current_backtrace_sources.push last_source.source_line
        elsif bkt.event.to_s == 'return'
          current_backtrace.pop
          current_backtrace_sources.pop
        end
        last_source = bkt
      end

      backtraces.uniq
    end
  end
end
