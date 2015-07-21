class ParamedicoController < ApplicationController
  
  def menu
    
    unless validacionParamedico()
      redirect_to controller: "principal", action: "index"
    end
    
    @citas=CitaMedica.where(["estado = ?",2]).order("fecha desc, hora_ini desc").group("pacientes_id")
    
  end
  
end