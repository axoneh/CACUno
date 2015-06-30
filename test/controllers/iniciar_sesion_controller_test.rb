require 'test_helper'

class IniciarSesionControllerTest < ActionController::TestCase
  test "should get iniciar" do
    get :iniciar
    assert_response :success
  end

end
