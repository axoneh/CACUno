class UsuarioController < ApplicationController
  def visualizar
    sesion=Sesion.getLogin();
    idSesion=nil;
    if sesion
      idSesion=sesion[:id];
      datoSesion=CuentaUsuario.find(idSesion);
      @nombreSesion=datoSesion.nombre+" "+datoSesion.apellido;
      rolSesion=datoSesion.rols_id;
      rolSesion=Rol.find(rolSesion);
      @cargoSesion=rolSesion.nombre;     
    end
    codigo=params[:id];
    if codigo
      datosUsuario=CuentaUsuario.find(codigo);
      if datosUsuario
        @identificacion=datosUsuario.identificacion;
        tipoD=datosUsuario.tipo_documentos_id;
        tipoD=TipoDocumento.find(tipoD);
        @tipoDocumento=tipoD.nombre;
        @nombre=datosUsuario.nombre;
        @apellido=datosUsuario.apellido;
        @correo=datosUsuario.correo;
        @genero="(Sin cargar)";
        if datosUsuario.genero
          @genero="Masculino";
        else
          @genero="Femenino";
        end
        @direccion=datosUsuario.direccion;
        estadoC=datosUsuario.estado_civils_id;
        estadoC=EstadoCivil.find(estadoC);
        @estadoCivil=estadoC.nombre;
        @estado="(Sin cargar)";
        if datosUsuario.estado
          @estado="Activo";
        else
          @estado="Inactivo";
        end
        rol=datosUsuario.rols_id;
        rol=Rol.find(rol);
        @cargo=rol.nombre;
        if sesion
          @propio=false;
          if codigo==idSesion
            @propio=true;
          end
        end
      else
        #404 Pagina no encontrada :v
      end
    else
      #404 Pagina no encontrada :v
    end
  end

  def actualizar
  end

  def agregar
  end
end
