class IniciarSesionController < ApplicationController
  def iniciar

    @respuesta="Ningun cambio aparente";

    if request.post?

      if params[:correo].present? && params[:password].present?

        correo=params[:correo];

        pass=params[:password];

        validacion = CuentaUsuario.exists?(["correo = ? and password = ?" , @correo, @pass]);

        if validacion

          @respuesta="Existe el usuario";

          id=CuentaUsuario.find_by(correo: correo);

          rol=Rol.find(id.id);

          session[:login]=true;
          session[:id]=id.id;
          session[:rol]=rol.nombre;

        else

          validacion = Autorizado.exists?(["correo = ? and password = ? and estado = ?" , correo, pass, 1]);

          if validacion

            @respuesta="Existe la autorizacion";

            session[:login]=true;
            session[:id]=id.id;
            session[:rol]="Autorizacion";

          #mandar a la pagina de registro de la cuenta

          else

            @respuesta="No se encontro usuario, verifique la informacion con algun administrador del sitio";

          end

        end

      end

    end

  end

end
