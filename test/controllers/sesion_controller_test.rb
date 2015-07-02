require 'test_helper'

class SesionControllerTest < ActionController::TestCase
  test "should get iniciar" do
    get :iniciar
    assert_response :success
  end

  test "should get cerrar" do
    get :cerrar
    assert_response :success
  end

end
