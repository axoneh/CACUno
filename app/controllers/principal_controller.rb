class PrincipalController < ApplicationController
  
  def index
    
    @admin=validacionAdmin()
    @medico=validacionMedico()
    @paramedico=validacionParamedico()
    @autorizado=validacionAutorizado()
    
    if @admin
      redirect_to controller: "administracion", action: "menu"
    elsif @medico
      redirect_to controller: "medico_internista", action: "menu"
    elsif @paramedico
      redirect_to controller: "paramedico", action: "menu"
    elsif @autorizado
      redirect_to controller: "usuario", action: "agregar"
    else
      if cuenta_usuario_signed_in?
        flash.notice="No tiene modulo asignado aun"
      end
    end  
  end

end