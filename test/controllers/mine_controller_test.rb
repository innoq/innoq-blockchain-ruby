require 'test_helper'

class MineControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mine_index_url
    assert_response :success
  end

end
