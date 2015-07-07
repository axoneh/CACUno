class PrincipalController < ApplicationController
  def index
    @rolAct=""
    if cuenta_usuario_signed_in?
      usuario=current_cuenta_usuario;
      if usuario.estado==1
        rol=Rol.find(usuario.rols_id);
        if rol
          if rol.nombre=="Administrador"
            redirect_to controller: "administracion", action: "menu"
          elsif rol.nombre=="Medico Especialista"
            redirect_to controller: "medico_internista", action: "menu"
          else
            redirect_to('Cerrar sesion', destroy_cuenta_usuario_session_path, method: :delete)
          end
        else
          redirect_to('Cerrar sesion', destroy_cuenta_usuario_session_path, method: :delete)
        end
      elsif usuario.estado==2
        redirect_to controller: "usuario", action: "agregar"
      elsif usuario.estado==3
        redirect_to('Cerrar sesion', destroy_cuenta_usuario_session_path, method: :delete)
      end
    end
  end

end