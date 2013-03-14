require 'test_helper'

class Admin::ProductControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
