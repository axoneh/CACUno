class PrincipalController < ApplicationController
  
  def contenido

    if @admin
      redirect_to controller: "administracion", action: "contenido"
    elsif @medico
      redirect_to controller: "medico_internista", action: "contenido"
    elsif @paramedico
      redirect_to controller: "paramedico", action: "contenido"
    elsif @autorizado
      redirect_to controller: "usuario", action: "agregar"
    else
      if cuenta_usuario_signed_in?
        flash.alert="No tiene modulo asignado aun"
      end
    end  
  end

end