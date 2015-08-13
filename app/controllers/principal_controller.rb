class PrincipalController < ApplicationController
  
  def contenido

    if @admin
      redirect_to controller: "administracion", action: "contenido"
    elsif @medico
      redirect_to controller: "medico_internista", action: "contenido"
    elsif @paramedico
      redirect_to controller: "cita_medica", action: "visualizar", usuario: current_cuenta_usuario.email, paramedico: true
    elsif @autorizado
      redirect_to controller: "usuario", action: "agregar"
    else
      flash.notice="Debe loguearse primero para entrar a la plataforma"
      redirect_to new_cuenta_usuario_session_path
    end  
  end

end