require_dependency "better_rails_debugger/application_controller"

module BetterRailsDebugger
  class GroupInstancesController < ApplicationController
    def objects
      begin
      @instance = GroupInstance.find params[:id]
      rescue Mongoid::Errors::DocumentNotFound
        redirect_to analysis_groups_path, flash: {error: 'Instance not found'}
        return
      end
      @objects = @instance.objects.order(created_at: 'desc').limit(20).paginate(page: (params[:page] || 1), per_page: 20)
    end

    def code
      begin
      @object = ObjectInformation.find(params[:object_id])
      rescue Mongoid::Errors::DocumentNotFound
        redirect_to group_instance_path(params[:id]), flash: {error: 'Object not found'}
        return
      end
      # Verify object existence
      theme = Rouge::Themes::Github.new
      formatter = Rouge::Formatters::HTMLInline.new theme
      lexer = Rouge::Lexers::Ruby.new
      render plain: formatter.format(lexer.lex(@object.source_code || ""))
    end
  end
end
