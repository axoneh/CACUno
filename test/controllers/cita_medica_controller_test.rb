require 'test_helper'

class CitaMedicaControllerTest < ActionController::TestCase
  test "should get crear" do
    get :crear
    assert_response :success
  end

  test "should get aplicar" do
    get :aplicar
    assert_response :success
  end

  test "should get efectuar" do
    get :efectuar
    assert_response :success
  end

  test "should get modificar" do
    get :modificar
    assert_response :success
  end

end
