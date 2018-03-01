module BetterRailsDebugger
  class ObjectInformation
    include ::Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :group_instance, class_name: "::BetterRailsDebugger::GroupInstance"

    field :ruby_object_id, type: Integer
    field :source_file, type: String
    field :source_line, type: Integer
    field :memsize, type: Integer
    field :class_name, type: String

    # Internal use
    field :source_code, type: String
    field :formatted_source_code, type: String

  end
end
