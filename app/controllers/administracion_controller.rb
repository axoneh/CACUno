class AdministracionController < ApplicationController
  
  def contenido #validacion de acceso al menu de administracion
    unless @admin
      redirect_to controller: "principal", action: "index"
    end
  end
  
end
