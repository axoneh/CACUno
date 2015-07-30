class ParamedicoController < ApplicationController
  
  def menu
    
    unless validacionParamedico()
      redirect_to controller: "principal", action: "index"
    else
      @citas=CitaMedica.joins(:prescripcions).select("cita_medicas.*, prescripcions.fechaFin as fechaFin").where(["cita_medicas.estado = ? and generico = ? and cita_medicas.tipo = ?",2, false, 'Presencial']).order("fecha desc, hora_ini desc").group("pacientes_id")
    end
  end
  
end