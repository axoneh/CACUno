class MedicoInternistaController < ApplicationController
  def contenido
    if @medico
      busqueda=params[:nombreP]
      @misCitas=CitaMedica.where(["estado = ? and cuenta_usuarios_id = ?",1, current_cuenta_usuario.id])
    else
      redirect_to controller: "principal", action: "contenido"
    end
  end

end
