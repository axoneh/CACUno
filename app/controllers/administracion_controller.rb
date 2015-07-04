class AdministracionController < ApplicationController
  
  def menu
    if cuenta_usuario_signed_in?
      usuario=current_cuenta_usuario;
      rol=Rol.find(usuario.rols_id);
      if rol and rol.nombre="Administrador"
        @nombre=usuario.nombre+" "+usuario.apellido
      else
        redirect_to controller: "principal", action: "index"
      end
    else
      redirect_to controller: "principal", action: "index"
    end 
  end
  
end
