class UsuarioController < ApplicationController
  def agregar
    if cuenta_usuario_signed_in?

      else
      redirect_to controller: "principal", action: "index"
    end
  end

  def actualizar
    if cuenta_usuario_signed_in?

      else
      redirect_to controller: "principal", action: "index"
    end
  end

  def visualizar
  end

  def autorizar
    if cuenta_usuario_signed_in?
      usuario=current_cuenta_usuario;
      rol=Rol.find(usuario.rols_id);
      if rol and rol.nombre="Administrador"
        @nombre=usuario.nombre+" "+usuario.apellido
        @roles=Rol.all
        @ingresado=false;
        if request.post?

      end
      else
        redirect_to controller: "principal", action: "index"
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def desautorizar
    if cuenta_usuario_signed_in?

      else
      redirect_to controller: "principal", action: "index"
    end
  end

  def desactivar
    if cuenta_usuario_signed_in?

      else
      redirect_to controller: "principal", action: "index"
    end
  end
end
