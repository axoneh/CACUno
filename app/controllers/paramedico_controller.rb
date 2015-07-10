class ParamedicoController < ApplicationController
  
  def menu
    if validacionParamedico()
      usuario=current_cuenta_usuario
      @nombre=usuario.nombre+" "+usuario.apellido
      pacientes=Paciente.joins(:cita_medicas)
      @pacientesProximos=nil                                          
      @fechaActual=Date.current
    else
      redirect_to controller: "principal", action: "index"
    end
  end
  
end
