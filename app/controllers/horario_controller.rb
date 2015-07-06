class HorarioController < ApplicationController
  def cargar
    @mensaje=""
    @lista=Hash.new
    @admin=validacionAdmin();
    if @admin
      usuario=current_cuenta_usuario
      cargo=Rol.find(usuario.rols_id)
      if cargo.nombre=="Administrador"
        redirect_to controller: "principal", action: "index"
      end
      @nombre=usuario.nombre+" "+usuario.apellido
    end
    if params[:correo].present?
      usuario=CuentaUsuario.find_by(email: params[:correo])
      @correo=usuario.email
      if usuario
        horarios=HorarioUsuario.where(["cuenta_usuarios_id = ?", usuario.id])
        horarios.each do |t|
          dia=DiaAsociado.find(t.dia_asociados_id)
          @lista[dia.numero]=dia.nombre+" - De: "+t.hora_ini+". hasta: "+t.hora_fin
        end
      else
        @mensaje="No se encontro horario con esa especificacion"
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def modificar
    if validacionAdmin()
      if params[:correo].present?
        usuario=CuentaUsuario.find_by(params[:correo])
        cargo=Rol.find(usuario.rols_id)
        if cargo.nombre=="Administrador"
          redirect_to controller: "principal", action: "index"
        end
        
      end
    else
      redirect_to controller: "principal", action: "index"
    end
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
