class UsuarioController < ApplicationController
  
  def agregar
    unless @autorizado
      redirect_to controller: "principal", action: "contenido"
    else
      if current_cuenta_usuario.rols.nombre=="Medico Especialista"
        @medico=true
      end
      @usuario=current_cuenta_usuario
      if actualizacion()
        redirect_to controller: "principal", action: "contenido"
      end
    end
  end

  def actualizar
    if @autenticado
      @usuario=current_cuenta_usuario
      if actualizacion()
        redirect_to controller: "principal", action: "contenido"
      end
    else
      redirect_to controller: "principal", action: "contenido"
    end
  end

  def visualizar
    @especifico=false;
    if params[:correo] and CuentaUsuario.exists?(["email = ?", params[:correo]])
      @especifico=true;
      @usuario=CuentaUsuario.find_by(email: params[:correo])
        
      @genero="(Sin cargar)"
      if(@usuario.genero)
        @genero="Masculino"
      else
        @genero="Femenino"
      end
      
    else
      @especifico=false;  
      @usuarios=CuentaUsuario.all
      if params[:busqueda].present?
        @usuarios=@usuarios.where(["CONCAT(nombre,' ',apellido) like ?", '%'+params[:busqueda]+'%'])
      end    
    end
  end

  def autorizar
    unless @admin
      redirect_to controller: "principal", action: "contenido"
    else
      unless params[:usuario].present?
        @documentos=TipoDocumento.where(["estado = ?", 1])
        @roles=Rol.all
        
        if request.post?
          if params[:correo].present? and params[:identificacion].present?
            encargado=params[:encr].present?
            correo=params[:correo]
            ident=params[:identificacion]
            tipoDoc=params[:documento]
            rol=params[:rol]
            if CuentaUsuario.exists?(["(identificacion = ? and tipo_documentos_id = ?) or email = ? ", ident, tipoDoc, correo])
              autorizado=CuentaUsuario.where(["(identificacion = ? and tipo_documentos_id = ?) or email= ?", ident, tipoDoc, correo]).first;
              if autorizado.rols.nombre=="Administrador" and autorizado.estado==1
                flash.alert="Existe ya una cuenta asociada a esa identificacion pero no se puede actualizar por motivos de permisos";
              else
                autorizado.password=Devise.friendly_token[0,20]
                autorizado.rols_id=rol
                autorizado.estado=2
                autorizado.email=correo
                autorizado.encargado_respuesta=encargado
                autorizado.save
                flash.notice="Existe ya una cuenta asociada a esa identificacion, se procedio a autorizar"
              end
            else
              CuentaUsuario.create(identificacion: ident, tipo_documentos_id: tipoDoc, email: correo, password: Devise.friendly_token[0,20], estado: 2, rols_id: rol, encargado_respuesta: encargado);
              flash.notice="Se genero la autorizacion exitosamente";
            end
          else
            if params[:correo].present?
              @valorCorreo=params[:correo]
            end
            if params[:identificacion].present?
              @valorIdentificacion=params[:identificacion]
            end
            flash.alert="Debe diligenciar todos los campos"
          end
        end
      else
        usuario=CuentaUsuario.find_by(email: params[:usuario])
        if usuario and usuario.estado==3
          usuario.estado=2;
          usuario.save
        end
        redirect_to controller: "usuario", action: "visualizar"
      end
    end
  end

  def desactivar
    unless @admin
      redirect_to controller: "principal", action: "contenido"
    else
      if params[:usuario].present?
        usuario=CuentaUsuario.find_by(email: params[:usuario])
        if usuario and usuario.rols.nombre!="Administrador"
          usuario.estado=3
          usuario.save
          flash.notice="Se realizado correctamente la desactivacion"
          redirect_to controller: "usuario", action: "visualizar"
        else
          flash.notice="No se puede desautorizar a este usuario"
          redirect_to controller: "usuario", action: "visualizar"
        end
      else
        redirect_to controller: "principal", action: "contenido"
      end
    end
  end
  
  def cambiar
    unless @admin
      redirec_to controller: "usuario", action: "visualizar"
    else
      if params[:usuario].present? and CuentaUsuario.exists?(["id = ?", params[:usuario]])
        @documentos=TipoDocumento.where(["estado = ?", 1])
        @roles=Rol.all
        usuario=CuentaUsuario.find(params[:usuario])
        if usuario and usuario.rols.nombre!="Administrador"
          @valorCorreo=usuario.email
          @valorIdentificacion=usuario.identificacion
          if request.post?
            if params[:correo].present? and params[:identificacion].present?
              encargado=params[:encr].present?
              correo=params[:correo]
              ident=params[:identificacion]
              tipoDoc=params[:documento]
              rol=params[:rol]
              if CuentaUsuario.exists?(["((identificacion = ? and tipo_documentos_id = ?) or email = ?) and id <> ? ", ident, tipoDoc, correo, usuario.id])
                flash.notice="Ya existe un usuario con esos datos, por favor verifique";
              else
                usuario.encargado_respuesta=encargado
                usuario.email=correo
                usuario.identificacion=ident
                usuario.tipo_documentos_id=tipoDoc
                usuario.rols_id=rol
                usuario.save
                redirect_to controller: "usuario", action: "visualizar", correo: usuario.email 
              end
            else
              if params[:correo].present?
                @valorCorreo=params[:correo]
              end
              if params[:identificacion].present?
                @valorIdentificacion=params[:identificacion]
              end
              flash.alert="Debe diligenciar todos los campos"
            end
          end
        else
          flash.alert="No puede modificar los datos de un administrador"
          redirect_to controller: "usuario", action: "visualizar"
        end
      else
        redirec_to controller: "usuario", action: "visualizar"
      end
    end
  end
  
private

  def actualizacion    
    @valorNombre= @usuario.nombre
    @valorApellido= @usuario.apellido
    @valorDireccion= @usuario.direccion
    @valorFecha= @usuario.fecha_nacimiento
    @valorEspecialidad=@usuario.especialidad

    if request.post?
      if params[:nombre].present? and params[:apellido].present? and params[:direccion].present? and params[:fecha].present?                               
        
        fechaN=params[:fecha]
        if params[:especialidad].present?
          especial=params[:especialidad]
        else
          especial=@usuario.rols.nombre
        end 
        nombre=params[:nombre]
        apellido=params[:apellido]
        genero=params[:genero]
        direccion=params[:direccion]
        
        @usuario.nombre=nombre
        @usuario.apellido=apellido
        @usuario.genero=genero
        @usuario.direccion=direccion
        @usuario.fecha_nacimiento=fechaN
        @usuario.especialidad=especial
        @usuario.password= Devise.friendly_token[0,20]
        
        @usuario.estado=1
        @usuario.save
                
        flash.notice="Actualizado exitosamente"
        
        sign_in(@usuario, :bypass=> true)
        
        return true
        
      else
        if params[:nombre].present?
          @valorNombre= params[:nombre]
        end
        if params[:apellido].present?
          @valorApellido=params[:apellido]
        end
        if params[:direccion].present?
          @valorDireccion=params[:direccion]
        end
        if params[:fecha].present?
          @valorFecha=params[:fecha]
        end
        if params[:especialidad].present?
          @valorEspecialidad=params[:especialidad]
        end
        flash.alert="Debe diligenciar todos los campos" 
      end
    end
  end
  
end
