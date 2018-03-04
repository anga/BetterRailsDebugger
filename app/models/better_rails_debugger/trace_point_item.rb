module BetterRailsDebugger
  class TracePointItem
    include Mongoid::Document

    belongs_to :group_instance, class_name: "::BetterRailsDebugger::GroupInstance"

    field :source_file, type: String
    field :source_line, type: Integer
    field :method_id, type: String
  end
end
