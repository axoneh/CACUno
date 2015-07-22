class CallbacksController < Devise::OmniauthCallbacksController
  
  def google_oauth2
    @user = CuentaUsuario.from_omniauth(request.env["omniauth.auth"])
    if @user
      if @user.estado==2
        @user.provider = request.env["omniauth.auth"].provider
        @user.uid = request.env["omniauth.auth"].uid
        @user.link_foto=request.env["omniauth.auth"].info.image
        @user.nombre=request.env["omniauth.auth"].info.first_name
        @user.apellido=request.env["omniauth.auth"].info.last_name
        @user.save
      end
      sign_in_and_redirect @user
    else
      flash.alert="No esta habilitado para loguearse"
      redirect_to controller: "principal", action: "index"
    end
  end
end
