class AdministracionController < ApplicationController
  
  def menu #validacion de acceso al menu de administracion
    unless validacionAdmin()
      redirect_to controller: "principal", action: "index"
    end
  end
  
end
