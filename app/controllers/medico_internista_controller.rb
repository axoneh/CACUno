class MedicoInternistaController < ApplicationController
  
  def menu
    if cuenta_usuario_signed_in?
      
    else
      redirect_to :controller=>"principal", :action=>"index"
    end 
  end

end
