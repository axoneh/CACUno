class ParamedicoController < ApplicationController
  
  def menu
    unless validacionParamedico()
      redirect_to controller: "principal", action: "index"
    end
    @citas=CitaMedica.select("*").where(["estado = ?",2]).order(fecha: :desc).select(:pacientes_id).distinct
    
  end
  
end
