class UsuarioController < ApplicationController
  
  def agregar
    validacion=validacionAutorizado()
    if validacion
      usuario=current_cuenta_usuario
      cargo=usuario.rols_id
      @mensaje="";
      
      @cargo=Rol.find(cargo)
      @cargo=@cargo.nombre
      @correo=usuario.email
      @identificacion= usuario.identificacion
      
      documento=usuario.tipo_documentos_id
      documento=TipoDocumento.find(documento)
      @documento=documento.nombre
      
      if request.post?
        if params[:nombre].present? and params[:apellido].present? and params[:direccion].present? and params[:fecha].present? and params[:especialidad].present?                                   
          
          fechaN=params[:fecha]
          especial=params[:especialidad]
          nombre=params[:nombre]
          apellido=params[:apellido]
          genero=params[:genero]
          direccion=params[:direccion]
          
          usuario.nombre=nombre
          usuario.apellido=apellido
          usuario.genero=genero
          usuario.direccion=direccion
          usuario.fecha_nacimiento=fechaN
          usuario.especialidad=especial
          
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
        @especialidad=usuario.especialidad
        @fechaN=usuario.fecha_nacimiento
        documento=usuario.tipo_documentos_id
        documento=TipoDocumento.find(documento)
        @documento=documento.nombre
        
        @direccion=usuario.direccion
        
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
        @horario=false;
        
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
            @horario=false;
            if cargo.nombre=="Administrador"
              @desactivar=true;
            else
              @desactivar=false;
            end
          else
            @modificar=false;
            if cargo.nombre=="Administrador"
              @desactivar=false;
              @horario=false
            else
              cargoSesion=current_cuenta_usuario.rols_id
              cargoSesion=Rol.find(cargoSesion)
              
              if cargoSesion.nombre=="Administrador"
                @desactivar=true;
                @horario=true;
              else 
                @desactivar=false;
                @horario=false;
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
      @documentos=TipoDocumento.where(["estado = ?", 1])
      @mensaje="";
      @roles=Rol.all
      if request.post?
        if params[:correo].present? and params[:identificacion].present?
          #pass=rand(1000000).to_s
          correo=params[:correo]
          ident=params[:identificacion]
          tipoDoc=params[:documento]
          rol=params[:rol]
          if CuentaUsuario.exists?(["identificacion = ? and tipo_documentos_id = ?", ident, tipoDoc])
            autorizado=CuentaUsuario.where(["identificacion = ? and tipo_documentos_id = ?", ident, tipoDoc]).first;
            cargo=autorizado.rols_id
            cargo=Rol.find(cargo)
            if cargo.nombre=="Administrador" and autorizado.estado==1
              @mensaje="Existe ya una cuenta asociada a esa identificacion pero no se puede actualizar por motivos de permisos";
            else
              autorizado.password="pass";
              autorizado.rols_id=rol;
              autorizado.estado=2;
              autorizado.email=correo
              autorizado.save();
              @mensaje="Existe ya una cuenta asociada a esa identificacion, se procedio a autorizar";
            end
          elsif CuentaUsuario.exists?(["email = ?", correo])
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
            CuentaUsuario.create(identificacion: ident, tipo_documentos_id: tipoDoc, nombre: '', apellido: '' , email: correo, password: "pass", direccion: '', genero: true, estado: 2, rols_id: rol);
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
