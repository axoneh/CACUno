require 'test_helper'

class AutorizadoControllerTest < ActionController::TestCase
  test "should get agregar" do
    get :agregar
    assert_response :success
  end

  test "should get actualizar" do
    get :actualizar
    assert_response :success
  end

  test "should get desactivar" do
    get :desactivar
    assert_response :success
  end

end
