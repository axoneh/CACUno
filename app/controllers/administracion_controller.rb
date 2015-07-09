class AdministracionController < ApplicationController
  
  def menu
    if validacionAdmin()
      usuario=current_cuenta_usuario
      @nombre=usuario.nombre+" "+usuario.apellido
    else
      redirect_to controller: "principal", action: "index"
    end
  end
  
end
