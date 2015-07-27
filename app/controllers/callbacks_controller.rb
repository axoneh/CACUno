class CallbacksController < Devise::OmniauthCallbacksController
  
  def google_oauth2
    x=request.env["omniauth.auth"]
    @user = CuentaUsuario.from_omniauth(x)
    if @user
      @user.provider = x.provider
      @user.uid = x.uid
      @user.link_foto=x.info.image
      @user.nombre=x.info.first_name
      @user.apellido=x.info.last_name
      @user.save
      sign_in_and_redirect @user
    else
      flash.alert="No esta habilitado para loguearse"
      redirect_to new_cuenta_usuario_session_path
    end
  end
end
