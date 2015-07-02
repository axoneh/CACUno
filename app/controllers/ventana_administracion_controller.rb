class VentanaAdministracionController < ApplicationController
  def inicial
    
    @respuesta=redireccionamiento();
    
  end

  def vista
  end

  def actualizar
  end
  
  private
  
  def redireccionamiento
    
    if defined?(session[:login]) and session[:login] and session[:rol]=="Administrador"
      
      return session;
      
    else
      
      return false;
      
    end
    
  end
end
