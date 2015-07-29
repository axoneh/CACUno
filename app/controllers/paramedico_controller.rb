class ParamedicoController < ApplicationController
  
  def menu
    
    unless validacionParamedico()
      redirect_to controller: "principal", action: "index"
    else
      @citas=CitaMedica.where(["estado = ? and generico = ? and tipo = ?",2, false, 'Presencial']).order("fecha desc, hora_ini desc").group("pacientes_id")
    end
  end
  
end