class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_action :authenticate_cuenta_usuario!
  #^para pedir autentificacion antes de entrar al controlador

  def validacionMedico
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        rol=Rol.find(current_cuenta_usuario.rols_id);
        if rol
          if rol.nombre=="Medico Especialista"
            return true
          else
            return false
          end
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end 

  def validacionEncargadoRespuesta
    if validacionMedico()
      if current_cuenta_usuario.encargado_respuesta==true
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def validacionAdmin
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        rol=Rol.find(current_cuenta_usuario.rols_id);
        if rol
          if rol.nombre=="Administrador"
            return true
          else
            return false
          end
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end

  def validacionParamedico
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        rol=Rol.find(current_cuenta_usuario.rols_id);
        if rol
          if rol.nombre=="Paramedico"
            return true
          else
            return false
          end
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end

  def validacionAutorizado
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==2
        return true
      else
        return false
      end
    else
      return false
    end
  end

end
