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

  test "should get visualizar" do
    get :visualizar
    assert_response :success
  end

  test "should get autorizar" do
    get :autorizar
    assert_response :success
  end

  test "should get desautorizar" do
    get :desautorizar
    assert_response :success
  end

  test "should get desactivar" do
    get :desactivar
    assert_response :success
  end

end
