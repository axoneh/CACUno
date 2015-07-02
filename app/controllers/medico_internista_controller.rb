class MedicoInternistaController < ApplicationController
  
  def menu
    sesion=Sesion.getLogin();
    if sesion and sesion[:rol]=="Medico Internista"
      datosSesion=CuentaUsuario.find(sesion[:id]);
      @nombreSesion=datosSesion.nombre+" "+datosSesion.apellido;
    else
      redirect_to :controller=>"sesion", :action=>"iniciar"
    end  
  end

end
