class HorarioController < ApplicationController
  
  def cargar
    @mensaje=""
    @lista=Hash.new
    @admin=validacionAdmin();
    if params[:correo].present?
      usuario=CuentaUsuario.find_by(email: params[:correo])
      if usuario
        @nombre= usuario.nombre+" "+usuario.apellido
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
      usuarioSesion=current_cuenta_usuario
      @nombre=usuarioSesion.nombre+" "+usuarioSesion.apellido
      @sucursales=Sucursal.where(["estado = ?", 1])
      @dias=DiaAsociado.where(["estado = ?",1])
      if params[:correo].present?
        usuario=CuentaUsuario.find_by(params[:correo])
        if usuario
          cargo=Rol.find(usuario.rols_id)
          @correo=usuario.email
          if cargo.nombre=="Administrador"
            redirect_to controller: "principal", action: "index"
          end
          if request.post?
            HorarioUsuario.delete_all(["cuenta_usuarios_id = ?", usuario.id])
            @dias.each do |t|
              if params[t.nombre].present?
                horarioN=HorarioUsuario.new
                
                horarioN.hora_inicial=params[t.nombre+"_ini"]
                horarioN.hora_final=params[t.nombre+"_fin"]
                horarioN.dia_asignados_id=@dias.id
                horarioN.cuenta_usuarios_id=usuario.id
                horarioN.sucursals_id=params[t.nombre_"sucursal"]
                
                horarioN.save
                
              end
            end
          end
        else
          redirect_to controller: "principal", action: "index"
        end
      else
        redirect_to controller: "principal", action: "index"
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
