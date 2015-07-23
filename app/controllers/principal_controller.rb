class PrincipalController < ApplicationController
  
  def index
    if validacionAdmin()
      redirect_to controller: "administracion", action: "menu"
    elsif validacionMedico()
      redirect_to controller: "medico_internista", action: "menu"
    elsif validacionParamedico()
      redirect_to controller: "paramedico", action: "menu"
    elsif validacionAutorizado()
      redirect_to controller: "usuario", action: "agregar"
    else
      if cuenta_usuario_signed_in?
        flash.notice="No tiene modulo asignado aun"
      end
    end  
  end

end