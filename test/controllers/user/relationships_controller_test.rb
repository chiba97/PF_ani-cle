require 'test_helper'

class User::RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_relationships_create_url
    assert_response :success
  end

  test "should get destroy" do
    get user_relationships_destroy_url
    assert_response :success
  end

end
