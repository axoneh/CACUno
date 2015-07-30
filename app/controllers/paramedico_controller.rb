class ParamedicoController < ApplicationController
  
  def contenido
    
    unless @paramedico
      redirect_to controller: "principal", action: "contenido"
    else
      @citas=CitaMedica.joins(:prescripcions).select("cita_medicas.*, prescripcions.fechaFin as fechaFin").where(["cita_medicas.estado = ? and generico = ? and cita_medicas.tipo = ?",2, false, 'Presencial']).order("fecha desc, hora_ini desc").group("pacientes_id")
    end
  end
  
end