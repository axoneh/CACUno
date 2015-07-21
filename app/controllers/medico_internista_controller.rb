class MedicoInternistaController < ApplicationController
  def menu
    if validacionMedico()
      busqueda=params[:nombreP]
      @encargado=validacionEncargadoRespuesta()
      if busqueda
        @pacientesAcorde=Paciente.where(["nombre||' '||apellido like ?", '%'+busqueda+'%'])
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

end
