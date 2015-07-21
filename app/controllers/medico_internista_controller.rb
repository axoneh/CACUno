class MedicoInternistaController < ApplicationController
  def menu
    if validacionMedico()
      busqueda=params[:nombreP]
      @encargado=validacionEncargadoRespuesta()
      @misCitas=CitaMedica.where(["estado = ?",1])
      if busqueda
        @pacientesAcorde=Paciente.where([" CONCAT(nombre,' ',apellido) like ?", '%'+busqueda+'%'])
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

end
