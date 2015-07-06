class UsuarioController < ApplicationController
  
  def agregar
    validacion=validacionAutorizado()
    if validacion
      usuario=current_cuenta_usuario
      cargo=usuario.rols_id
      @mensaje="";
      @documentos=TipoDocumento.all
      @estadosC=EstadoCivil.all
      @cargo=Rol.find(cargo)
      @cargo=@cargo.nombre
      @correo=usuario.email
      if request.post?
        if (params[:ident].present? and params[:documento].present? and params[:nombre].present? and params[:apellido].present? and params[:genero].present? and params[:direccion].present? and params[:ecivil].present?)
          identificacion=params[:ident]
          documento=params[:documento]
          nombre=params[:nombre]
          apellido=params[:apellido]
          genero=params[:genero]
          estadoC=params[:ecivil]
          direccion=params[:direccion]
          
          if CuentaUsuario.exists?(["identificacion = ? and tipo_documentos_id = ?", identificacion , documento])
            @mensaje="NO se pudieron guardar sus datos, por favor corrobore la informacion";
          else
            usuario.identificacion=identificacion
            usuario.tipo_documentos_id=documento
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
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def actualizar
    
  end

  def visualizar
  end

  def autorizar
    validacion=validacionAdmin()
    if validacion
      usuario=current_cuenta_usuario
      @nombre=usuario.nombre+" "+usuario.apellido
      @mensaje="";
      @roles=Rol.all
      if request.post?
        if params[:correo].present? and params[:rol].present?
          #pass=rand(1000000).to_s
          correo=params[:correo]
          rol=params[:rol]
          if CuentaUsuario.exists?(["email = ?", correo])
            autorizado=CuentaUsuario.find_by(email: correo);
            cargo=autorizado.rols_id
            cargo=Rol.find(cargo)
            if cargo.nombre=="Administrador" and autorizado.estado==1
              @mensaje="Existe ya una cuenta asociada a ese correo pero no se puede actualizar por motivos de permisos";
            else
              autorizado.password=pass;
              autorizado.rols_id=rol;
              autorizado.estado=2;
              autorizado.save();
              @mensaje="Existe ya una cuenta asociada a ese correo, se procedio a autorizar";
            end
          else
            CuentaUsuario.create(identificacion: nil, tipo_documentos_id: nil, nombre: '', apellido: '' , email: correo, password: pass, direccion: '', estado_civils_id: 1, genero: true, estado: 2, rols_id: rol);
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
