require_dependency "better_rails_debugger/application_controller"

module BetterRailsDebugger
  class AnalysisGroupsController < ApplicationController

    before_action :get_group, only: [:show, :edit, :update, :destroy]

    def index
      @groups = AnalysisGroup.order(name: 'asc').limit(20).paginate(page: (params[:page] || 1), per_page: 20)
    end

    def show
      if !@group
        redirect_to analysis_groups_path, notice: 'Analysis group not found'
        return
      end
      @instances = @group.group_instances.order(created_at: 'desc').limit(20).paginate(page: (params[:page] || 1), per_page: 20)
    end

    def new
      @group = AnalysisGroup.new
    end

    def create
      @group = AnalysisGroup.new analysis_group_params
      if @group.save
        redirect_to analysis_groups_path, notice: 'Successfully created!'
      else
        flash.now[:error] = @group.errors.full_messages
        render 'new'
      end
    end

    def edit
      if !@group
        redirect_to analysis_groups_path, notice: 'Analysis group not found'
        return
      end
    end

    def update
      if !@group
        redirect_to analysis_groups_path, notice: 'Analysis group not found'
        return
      end
      if @group.update_attributes(analysis_group_params)
        redirect_to analysis_groups_path, notice: 'Updated successfully'
        return
      else
        flash.now[:error] = @group.errors.full_messages
        render 'edit'
      end
    end

    def destroy
      if !@group
        redirect_to analysis_groups_path, notice: 'Analysis group not found'
        return
      end
      @group.destroy
      redirect_to analysis_groups_path, notice: 'Analysis group destroyed'
    end

    private
    def analysis_group_params
      params.require(:analysis_group).permit([:name, :collect_memory_information, :analise_memory_in_code,
                                              :analise_memory_in_gems, :record_objects_in, :times_to_run,
                                              :analyze_repeated_instances, :generate_method_execution_history,
                                              :calculate_execution_time_of_methods])
    end

    def get_group
      @group = AnalysisGroup.find(params[:id])
    end
  end
end
