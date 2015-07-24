class MedicoInternistaController < ApplicationController
  def menu
    if validacionMedico()
      busqueda=params[:nombreP]
      @encargado=validacionEncargadoRespuesta()
      @misCitas=CitaMedica.where(["estado = ? and cuenta_usuarios_id = ?",1, current_cuenta_usuario.id])
      if busqueda
        @pacientesAcorde=Paciente.where([" CONCAT(nombre,' ',apellido) like ?", '%'+busqueda+'%'])
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

end
