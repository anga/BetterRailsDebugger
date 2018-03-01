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

      theme = Rouge::Themes::Github.new()
      formatter = Rouge::Formatters::HTMLInline.new theme
      lexer = Rouge::Lexers::Ruby.new

      instance.objects.all.each do |object|
        start = (l = object.source_line - 4) >= 0 ? l : 0
        # TODO: Optimize this
        object.source_code =  IO.readlines(object.source_file)[start..(object.source_line + 4)].join("\n")
        # object.formatted_source_code = formatter.format(lexer.lex(object.source_code || ""))
        object.save
      end

    end
  end
end
