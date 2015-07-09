class PrincipalController < ApplicationController
  
  def index
    if validacionAdmin()
      redirect_to controller: "administracion", action: "menu"
    elsif validacionMedico()
      redirect_to controller: "medico_internista", action: "menu"
    elsif validacionParamedico()
      
    elsif validacionAutorizado()
      redirect_to controller: "usuario", action: "agregar"
    end  
  end

end