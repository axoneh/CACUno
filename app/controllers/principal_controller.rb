class PrincipalController < ApplicationController
  def index
    if cuenta_usuario_signed_in?
      usuario=current_cuenta_usuario;
      rol=Rol.find(usuario.rols_id);
      if rol and rol.nombre="Administrador"
        redirect_to controller: "administracion", action: "menu"
      elsif rol and rol.nombre="Medico Internista"
        redirect_to controller: "principal", action: "index"
      end
    end
  end

end