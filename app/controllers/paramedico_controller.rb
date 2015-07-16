class ParamedicoController < ApplicationController
  
  def menu
    unless validacionParamedico()
      redirect_to controller: "principal", action: "index"
    end
    @citas=CitaMedica.select("*").select(:pacientes_id).distinct.where(["estado = ?",2]).order(fecha: :desc)
    
  end
  
end
