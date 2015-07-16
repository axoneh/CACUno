class CallbacksController < Devise::OmniauthCallbacksController
  
  def google_oauth2
    @user = CuentaUsuario.from_omniauth(request.env["omniauth.auth"])
    if @user
      sign_in_and_redirect @user
    else
      flash.alert="No esta habilitado para loguearse"
      redirect_to controller: "principal", action: "index"
    end
  end
end
