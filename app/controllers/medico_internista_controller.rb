class MedicoInternistaController < ApplicationController
  def menu
    if validacionMedico()
      busqueda=params[:nombreP].present?
      @encargado=validacionEncargadoRespuesta()
      if busqueda
        @pacientesAcorde=Paciente.where(["nombre||' '||apellido like ?", '%'+params[:nombreP]+'%'])
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

end
