class PacienteController < ApplicationController
  
  def agregar
    if validacionAdmin()
      @mensaje=""
      usuario=current_cuenta_usuario
      @nombre=usuario.nombre+" "+usuario.apellido
      @documentos=TipoDocumento.where(["estado = ?", 1])
      @estadosC=EstadoCivil.where(["estado = ?", 1])
      @patologias=Patologia.where(["estado = ?", 1])
      @antecedentes=AntecedentePaciente.where(["estado = ? ", 1])
      if request.post?
        if params[:correo].present? and params[:nombre].present? and params[:apellido].present? and params[:identificacion] and params[:direccion]
          correo=params[:correo]
          nombre=params[:nombre]
          apellido=params[:apellido]
          ident=params[:identificacion]
          direccion=params[:direccion]
          documento=params[:documento]
          genero=params[:genero]
          estadoC=params[:estadoC]
          patologia=params[:patologia]
          if Paciente.exists?(["correo = ?",correo])
            @mensaje="Ya existe ese correo registrado, por favor verifique los datos"
          elsif Paciente.exists?(["identificacion = ? and tipo_documentos_id = ?", ident, documento])
            @mensaje="Ya existe un usuario con ese documento, verifique los datos"
          else
            paciente=Paciente.new
            paciente.correo=correo
            paciente.nombre=nombre
            paciente.apellido=apellido
            paciente.identificacion=ident
            paciente.direccion=direccion
            paciente.tipo_documentos_id=documento
            paciente.genero=genero
            paciente.estado_civils_id=estadoC
            paciente.patologia_id=patologia
            paciente.estado=1
            paciente.save
            @mensaje="Agregado exitoso de paciente"
            idpaciente=paciente.id
            AntecedentePaciente.delete_all(["pacientes_id = ?", idpaciente])
            @antecedentes.each do |a|
              if params[a.id].present?
                if a.tipo
                  AntecedentePaciente.create(pacientes_id: idpaciente, antecedente_medicos_id: a.id, comentario: params[a.id+"_comentario"])
                end
              end  
            end
          end
        end
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def actualizar
    if validacionAdmin()
      
    else
      redirect_to controller: "principal", action: "index"
    end
  end
  
  def visualizar
    @especifico=false
    @mensaje=""
    if params[:correo]
      @especifico=true
      if Paciente.exists?(["correo = ?", params[:correo]])
        paciente=Paciente.find_by(correo: params[:correo])
        @nombre=paciente.nombre
        @apellido=paciente.apellido
        @correo=paciente.correo
        @ide=paciente.identificacion
        
        documento=paciente.tipo_documentos_id
        documento=TipoDocumento.find(documento)
        @documento=documento.nombre
        
        @direccion=paciente.direccion
        
        @genero="(Sin cargar)"
        if paciente.genero==1
          @genero="Masculino"
        else
          @genero="Femenino"
        end
        
        estadoC=paciente.estado_civils_id
        estadoC=EstadoCivil.find(estadoC)
        @estadoC=estadoC.nombre
        
        patologia=paciente.patologia_id
        patologia=Patologia.find(patologia)
        @patologia=patologia.nombre
        @desPatologia=patologia.descripcion
        @fechaN=paciente.fecha_nacimiento
        
        @inr="--"
        @fecha="(Sin referencia encontrada)"
        @prescripcion=nil
        @prescripcionDiaria=nil
        @anticoagulante=nil
        cita=CitaMedica.where(["pacientes_id = ? and estado= ?", paciente.id, 1]).order(fecha: :desc).first
        if cita
          
          inr=InrPaciente.where(["cita_medicas_id = ?", cita.id]).order([fecha: :desc]).first
          if inr
            @inr=inr.valorInr
            @fecha=inr.fecha
          end
          
          respuesta=RespuestaCita.find_by(cita_medicas_id: cita.id)
          if respuesta
            @prescripcion=Prescripcion.find_by(respuesta_cita_id: respuesta.id)
            if @prescripcion
              @anticoagulante=Anticoagulante.find_by(@prescripcion.anticoagulantes_id)
              @prescripcionDiaria=PrescripcionDiaria.joins(:dia_asociados, :prescripcions).select("dia_asociados.nombre as dia, prescripcion_diaria.cantidadGramos as cantidad").where(["prescripcion_diaria.prescripcions_id = ?", prescripcion.id])                                                  
            end
          end
          
        end
        
      else
        @mensaje="No se encontro registro con esa especificacion"
      end
    else
      @especifico=false
      @pacientes=Paciente.all
    end
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
  
  def validacionMedico
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        rol=Rol.find(current_cuenta_usuario.rols_id);
        if rol
          if rol.nombre=="Medico Espesialista"
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
  
end
