require 'test_helper'

class PacienteControllerTest < ActionController::TestCase
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

end
