require File.dirname(__FILE__) + '/../test_helper'
require 'admin/dashboard_controller'

class Admin::DashboardController; def rescue_action(e) raise e end; end

class DashboardControllerTest < ActionController::TestCase
  
  fixtures :users, :pages
  
  def setup
    @controller = Admin::DashboardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_should_get_index
    login_as(:quentin)
    
    # update a page to generate recent activity
    pages(:home_page).update_attribute(:title, "Welcome")
    
    get :index
    assert_response :success
    assert_not_nil assigns(:recent_activity)
    
    raise assigns(:recent_activity).inspect
  end
  
  def test_should_require_login_and_redirect
    get :index
    assert_response :redirect
    assert_nil assigns(:recent_activity)
  end
  
  # we need to somehow make it so that recent activity comes
  # into tests so we can check the order.
  # not sure why the recent activity assign has no activity
  
end