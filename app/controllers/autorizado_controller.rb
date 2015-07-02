class AutorizadoController < ApplicationController
  
  def agregar
    sesion=Sesion.getLogin();
    if sesion and sesion[:rol]=="Administracion"
      datosSesion=CuentaUsuario.find(sesion[:id]);
      @nombreSesion=datosSesion.nombre+" "+datosSesion.apellido;
    else
      #mandar a iniciar sesion
    end
    @roles=Rol.all;
    @respuesta="";
    @cargo="";
    if request.post?
      if params[:correo].present? and params[:cargo].present?
        correo=params[:correo];
        cargo=params[:cargo];
        @cargo=cargo;
        validacion=Autorizado.exists?(["correo = ? and estado = ?",correo, true]);
        if validacion
          @respuesta="Como ya existe una cuenta activada, por tanto no se efectuo ninguna insercion";
        else
          validacion=Autorizado.exists?(["correo = ? and estado = ?",correo, false]);
          if validacion
            autorizacion=Autorizado.find(correo: correo);
            autorizacion.estado=true;
            autorizacion.save();
            @respuesta="Como ya existe una cuenta pero desactivada, se procedio a activar";
          else
            pass=rand(999999).to_s;
            Autorizado.create(:correo => correo, :rols_id => cargo, :estado => true, :password => pass);
            @respuesta="Se agrego la autorizacion a dicho correo";
          end
          #enviar correo para recientemente agregados
        end
      end
    end
  end

  def actualizar
    
  end

  def desactivar
    
  end
end
