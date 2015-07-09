class MedicoInternistaController < ApplicationController
  def menu
    if validacionMedico()
      usuario=current_cuenta_usuario
      @nombre=usuario.nombre+" "+usuario.apellido
      @busqueda=params[:nombreP].present?
      if @busqueda
        @pacientesAcorde=Paciente.where(["nombre||' '||apellido like ?", '%'+params[:nombreP]+'%'])
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

end
