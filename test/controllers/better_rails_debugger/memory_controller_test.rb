require 'test_helper'

module BetterRailsDebugger
  class MemoryControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get memory_index_url
      assert_response :success
    end

  end
end
