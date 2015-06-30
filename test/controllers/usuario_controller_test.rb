require 'test_helper'

class UsuarioControllerTest < ActionController::TestCase
  test "should get agregar" do
    get :agregar
    assert_response :success
  end

  test "should get actualizar" do
    get :actualizar
    assert_response :success
  end

end
