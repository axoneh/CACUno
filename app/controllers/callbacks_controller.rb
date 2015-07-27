class CallbacksController < Devise::OmniauthCallbacksController
  
  def google_oauth2
    @user = CuentaUsuario.from_omniauth(request.env["omniauth.auth"])
    if @user
      @user.provider = request.env["omniauth.auth"].provider
      @user.uid = request.env["omniauth.auth"].uid
      @user.link_foto=request.env["omniauth.auth"].info.image
      @user.nombre=request.env["omniauth.auth"].info.first_name
      @user.apellido=request.env["omniauth.auth"].info.last_name
      @user.save
      sign_in_and_redirect @user
    else
      flash.alert="No esta habilitado para loguearse"
      redirect_to new_cuenta_usuario_session_path
    end
  end
end
