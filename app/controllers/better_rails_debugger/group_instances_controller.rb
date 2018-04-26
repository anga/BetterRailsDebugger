require_dependency "better_rails_debugger/application_controller"

module BetterRailsDebugger
  class GroupInstancesController < ApplicationController
    def show
      begin
        @instance = GroupInstance.find params[:id]
      rescue Mongoid::Errors::DocumentNotFound
        redirect_to analysis_groups_path, flash: {error: 'Instance not found'}
        return
      end
      @most_used_methods = @instance.most_used_methods(4)
      @file_allocations  = @instance.files_with_more_allocations(4)
    end

    def tracer
      begin
        @instance = GroupInstance.find params[:id]
      rescue Mongoid::Errors::DocumentNotFound
        redirect_to analysis_groups_path, flash: {error: 'Instance not found'}
        return
      end
      @traces = @instance.trace_point_items.order(created_at: 'desc').limit(20)
      filter_traces
      @traces = @traces.paginate(page: (params[:page] || 1), per_page: 20)

      @file_allocations = @instance.files_with_more_allocations(4)
    end

    def objects
      begin
        @instance = GroupInstance.find params[:id]
      rescue Mongoid::Errors::DocumentNotFound
        redirect_to analysis_groups_path, flash: {error: 'Instance not found'}
        return
      end
      @objects = @instance.objects.order(created_at: 'desc').limit(20)
      filter_objects
      @objects = @objects.paginate(page: (params[:page] || 1), per_page: 20)

      @file_allocations = @instance.files_with_more_allocations(4)
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

    def backtrace
      begin
        @instance = GroupInstance.find params[:id]
      rescue Mongoid::Errors::DocumentNotFound
        redirect_to analysis_groups_path, flash: {error: 'Instance not found'}
        return
      end
      @backtraces = ::BetterRailsDebugger::TracePointItem.backtraces_for(params[:id], params[:file], params[:line].to_i)
      pp @backtraces
    end

    private
    def filter_objects
      if ['asc', 'desc'].include? params[:order] and ['location', 'memsize', 'class'].include? params[:column]
        if params[:column] == 'location'
          @objects = @objects.order({source_file: params[:order], source_line: params[:order]})
        elsif params[:column] == 'memsize'
          @objects = @objects.order({memsize: params[:order]})
        elsif params[:column] == 'class'
          @objects = @objects.order({class_name: params[:order]})
        end
      end
      if params[:filter].present?
        @objects = @objects.or({source_file: /.*#{params[:filter]}.*/i},
                               {source_line: /.*#{params[:filter]}.*/i},
                               {memsize:     /.*#{params[:filter]}.*/i},
                               {class_name:  /.*#{params[:filter]}.*/i})
      end
    end

    def filter_traces
      if ['asc', 'desc'].include? params[:order] and ['location', 'method', 'times'].include? params[:column]
        if params[:column] == 'location'
          @traces = @traces.order({source_file: params[:order], source_line: params[:order]})
        elsif params[:column] == 'method'
          @traces = @traces.order({method_id: params[:order]})
        end
      end
      if params[:filter].present?
        @objects = @objects.or({source_file: /.*#{params[:filter]}.*/i},
                               {source_line: /.*#{params[:filter]}.*/i},
                               {memsize:     /.*#{params[:filter]}.*/i},
                               {class_name:  /.*#{params[:filter]}.*/i})
      end
    end
  end
end
