class UsuarioController < ApplicationController
  
  def agregar
    validacion=validacionAutorizado()
    if validacion
      usuario=current_cuenta_usuario
      cargo=usuario.rols_id
      @mensaje="";
      @estadosC=EstadoCivil.all
      
      @cargo=Rol.find(cargo)
      @cargo=@cargo.nombre
      @correo=usuario.email
      @identificacion= usuario.identificacion
      @documento=usuario.tipo_documentos_id
      @documento=TipoDocumento.nombre
      if request.post?
        if (params[:nombre].present? and params[:apellido].present? and params[:genero].present? and params[:direccion].present? and params[:ecivil].present?)
          nombre=params[:nombre]
          apellido=params[:apellido]
          genero=params[:genero]
          estadoC=params[:ecivil]
          direccion=params[:direccion]
          
          usuario.nombre=nombre
          usuario.apellido=apellido
          usuario.genero=genero
          usuario.direccion=direccion
          usuario.estado_civils_id=estadoC
          
          usuario.estado=1
          usuario.save
          
          redirect_to controller: "principal", action: "index"
          
        end
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def actualizar
    
  end

  def visualizar
    if cuenta_usuario_signed_in?
      usuario=current_cuenta_usuario
      @nombreSesion=usuario.nombre+" "+usuario.apellido
    end
    
    if validacionAutorizado()
      redirect_to controller: "principal", action: "index"
    end
    
    @especifico=false;
    @mensaje="";
    if params[:correo]
      @especifico=true;
      usuario=CuentaUsuario.find_by(email: params[:correo])
      if usuario
        @nombre=usuario.nombre;
        @apellido=usuario.apellido
        @correo=usuario.email
        @identificacion=usuario.identificacion
        
        documento=usuario.tipo_documentos_id
        documento=TipoDocumento.find(documento)
        @documento=documento.nombre
        
        @direccion=usuario.direccion
        
        estadoC=usuario.estado_civils_id
        estadoC=EstadoCivil.find(estadoC)
        @estadoC=estadoC.nombre
        
        @genero="(Sin cargar)"
        if(usuario.genero==1)
          @genero="Masculino"
        else
          @genero="Femenino"
        end
        
        cargo=usuario.rols_id
        cargo=Rol.find(cargo)
        @cargo=cargo.nombre
        
        @modificar=false;
        @desactivar=false;
        
        estado=usuario.estado;
        @estado="(Sin cargar)"
        if estado==1
          @estado="Activo"
        elsif estado==2
          @estado="Por autenticar"
        else 
          @estado="Inactivo"
        end
        
        if cuenta_usuario_signed_in?
          if usuario.email==current_cuenta_usuario.email
            @modificar=true;
            if cargo.nombre=="Administrador"
              @desactivar=true;
            else
              @desactivar=false;
            end
          else
            @modificar=false;
            if cargo.nombre=="Administrador"
              @desactivar=false;
            else
              cargoSesion=current_cuenta_usuario.rols_id
              cargoSesion=Rol.find(cargoSesion)
              
              if cargoSesion.nombre=="Administrador"
                @desactivar=true;
              else 
                @desactivar=false;
              end
            end
          end
        else
          @modificar=false;
          @desactivar=false;
        end
        
      else
        @mensaje="No se encontro registro con esa especificacion"
      end
    else
      @especifico=false;  
      @usuarios=CuentaUsuario.all    
    end
  end

  def autorizar
    validacion=validacionAdmin()
    if validacion
      usuario=current_cuenta_usuario
      @nombre=usuario.nombre+" "+usuario.apellido
      @documentos=TipoDocumento.all
      @mensaje="";
      @roles=Rol.all
      if request.post?
        if params[:correo].present? and params[:rol].present? and params[:identificacion].present? and params[:tipoD].present?
          #pass=rand(1000000).to_s
          correo=params[:correo]
          ident=params[:identificacion]
          tipoDoc=params[:documento]
          rol=params[:rol]
          if CuentaUsuario.exists?(["email = ?", correo])
            autorizado=CuentaUsuario.find_by(email: correo);
            cargo=autorizado.rols_id
            cargo=Rol.find(cargo)
            if cargo.nombre=="Administrador" and autorizado.estado==1
              @mensaje="Existe ya una cuenta asociada a ese correo pero no se puede actualizar por motivos de permisos";
            else
              autorizado.password="pass";
              autorizado.identificacion=ident;
              autorizado.tipo_documentos_id=tipoDoc;
              autorizado.rols_id=rol;
              autorizado.estado=2;
              autorizado.save();
              @mensaje="Existe ya una cuenta asociada a ese correo, se procedio a autorizar";
            end
          else
            CuentaUsuario.create(identificacion: ident, tipo_documentos_id: tipoDoc, nombre: '', apellido: '' , email: correo, password: "pass", direccion: '', estado_civils_id: 1, genero: true, estado: 2, rols_id: rol);
            @mensaje="Se genero la autorizacion exitosamente";
          end
        else
          
        end
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def desactivar

  end
  
  private
  
  def validacionAdmin
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        rol=Rol.find(current_cuenta_usuario.rols_id);
        if rol
          if rol.nombre=="Administrador"
            return true
          else
            return false
          end
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end
  
  def validacionAutorizado
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==2
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
end
