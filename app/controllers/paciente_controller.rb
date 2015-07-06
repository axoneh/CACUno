class PacienteController < ApplicationController
  def agregar
    if validacionAdmin()
      
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def actualizar
  end
  
  private
  
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
  
end
