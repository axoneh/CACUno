class MedicoInternistaController < ApplicationController
  def menu
    if cuenta_usuario_signed_in?
      usuario=current_cuenta_usuario;
      if usuario.estado==1
        rol=Rol.find(usuario.rols_id);
        if rol and rol.nombre="Medico Internista"
          @nombre=usuario.nombre+" "+usuario.apellido
          @busqueda=params[:nombreP].present?
          if @busqueda
            @pacientesAcorde=Paciente.where(["nombre||' '||apellido like ?", '%'+params[:nombreP]+'%'])
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

end
