require 'test_helper'

class VentanaAdministracionControllerTest < ActionController::TestCase
  test "should get inicial" do
    get :inicial
    assert_response :success
  end

  test "should get vista" do
    get :vista
    assert_response :success
  end

  test "should get actualizar" do
    get :actualizar
    assert_response :success
  end

end
