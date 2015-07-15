class ParamedicoController < ApplicationController
  
  def menu
    unless validacionParamedico()
      redirect_to controller: "principal", action: "index"
    end
  end
  
end
