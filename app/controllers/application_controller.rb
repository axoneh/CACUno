class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_cuenta_usuario! , :except=>[:index]
  #before_action :authenticate_cuenta_usuario!
  #^para pedir autentificacion antes de entrar al controlador
protected
  def validacionMedico #validacion para saber si fue un medico quien entro al sistema
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        if current_cuenta_usuario.rols.nombre=="Medico Especialista"
          return true
        end
      end
    end
  end 

  def validacionEncargadoRespuesta #validacion para saber si quien entro al sistema esta autorizado para realizar respuestas a consultas domiciliarias
    if validacionMedico()
      if current_cuenta_usuario.encargado_respuesta
        return true
      end
    end
  end

  def validacionAdmin #validacion para saber si fue un admin quien entro al sistema
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
          if current_cuenta_usuario.rols.nombre=="Administrador"
            return true
          end
      end
    end
  end

  def validacionParamedico #validacion para saber si fue un paramedico quien entro al sistema
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        if current_cuenta_usuario.rols.nombre=="Paramedico"
          return true
        end
      end
    end
  end

  def validacionAutorizado #validacion para saber si quien entro al sistema esta por validar datos
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==2
        return true
      end
    end
  end

  def validacionUsuario
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        return true
      end
    end
  end

end
