require 'test_helper'

class HorarioControllerTest < ActionController::TestCase
  test "should get cargar" do
    get :cargar
    assert_response :success
  end

  test "should get modificar" do
    get :modificar
    assert_response :success
  end

end
