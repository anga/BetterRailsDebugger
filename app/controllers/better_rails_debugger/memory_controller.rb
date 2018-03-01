require_dependency "better_rails_debugger/application_controller"

module BetterRailsDebugger
  class MemoryController < ApplicationController
    before_action :get_request, only: [:show, :analize]
    def index
      @requests = MemoryRequestStatus.order(created_at: 'desc').limit(20).paginate(page: (params[:page] || 1), per_page: 5)
    end

    def show
    end

    def analize
    end

    private
    def get_request
      @request = MemoryRequestStatus.find(params[:id])
    end
  end
end
