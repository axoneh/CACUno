class SesionController < ApplicationController
  
  def iniciar
    enrutar();
    @respuesta="";
    if request.post?
      if params[:correo].present? && params[:password].present?
        correo=params[:correo];
        pass=params[:password];
        validacion = CuentaUsuario.exists?(["correo = ? and password = ? and estado = ?" , correo, pass, true]);
        if validacion
          id=CuentaUsuario.find_by(correo: correo);
          rol=Rol.find(id.id);
          session[:login]=true;
          session[:id]=id.id;
          session[:rol]=rol.nombre;
          enrutar();
        else
          validacion = Autorizado.exists?(["correo = ? and password = ? and estado = ?" , correo, pass, true]);
          if validacion
            id=Autorizado.find_by(correo: correo);
            session[:login]=true;
            session[:id]=id.id;
            session[:rol]="Autorizacion";
            enrutar();
          else
            @respuesta="No se encontro usuario, verifique la informacion con algun administrador del sitio";
          end
        end
      end
    end
  end

  def cerrar
    session[:login]=false;
    session[:id]=nil;
    session[:rol]=nil;
  end
  
  private
  def enrutar
    if defined?(session[:login]) and session[:login]
      case session[:rol]
      when "Administrador"
        redirect_to :controller=>"administracion", :action=>"menu";
      when "Medico Internista"
        redirect_to :controller=>"medico_internista", :action=>"menu";
      end
    end
  end
  
end
