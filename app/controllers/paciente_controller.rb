class PacienteController < ApplicationController
  
  def agregar
    if validacionAdmin() or validacionMedico()
      @mensaje=""
      usuario=current_cuenta_usuario
      @nombre=usuario.nombre+" "+usuario.apellido
      
      @documentos=TipoDocumento.where(["estado = ?", 1])
      @estadosC=EstadoCivil.where(["estado = ?", 1])
      @patologias=Patologia.where(["estado = ?", 1])
      @antecedentes=AntecedenteMedico.where(["estado = ? ", 1])
      
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
          fechaN=params[:fecha_n]
          if Paciente.exists?(["correo = ?",correo])
            @mensaje="Ya existe ese correo registrado, por favor verifique los datos"
          elsif Paciente.exists?(["identificacion = ? and tipo_documentos_id = ?", ident, documento])
            @mensaje="Ya existe un usuario con ese documento, verifique los datos"
          else
            paciente=Paciente.new
            paciente.fecha_nacimiento=fechaN
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
              if params[a.id.to_s].present?
                if a.tipo
                  AntecedentePaciente.create(pacientes_id: idpaciente, antecedente_medicos_id: a.id, comentario: params[a.id.to_s+"_comentario"])
                else
                  AntecedentePaciente.create(pacientes_id: idpaciente, antecedente_medicos_id: a.id)
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
    @medico=validacionMedico()
    @paramedico=validacionParamedico()
    if params[:correo].present?
      @especifico=true
      if Paciente.exists?(["correo = ?", params[:correo]])
        paciente=Paciente.find_by(correo: params[:correo])
        @nombre=paciente.nombre
        @apellido=paciente.apellido
        @correo=paciente.correo
        @ide=paciente.identificacion
        
        @fechaActual=Date.current
        
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
        @antecedentesPaciente=nil
        @citasMedicas=nil
        
        cita=CitaMedica.where(["pacientes_id = ? and estado= ?", paciente.id,2]).order(fecha: :desc).first
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
              @prescripcionDiaria=PrescripcionDiaria.joins(:dia_asociados, :prescripcions).select("dia_asociados.nombre as dia, prescripcion_diaria.cantidadGramos as cantidad").where(["prescripcion_diaria.prescripcions_id = ?", @prescripcion.id])                                                  
            end
          end
          
        end

        @antecedentesPaciente=AntecedentePaciente.joins(:antecedente_medicos).select("*").where(["pacientes_id = ?", paciente.id])
        
        @citasMedicas=CitaMedica.joins(:inr_pacientes).select("inr_pacientes.valorInr as inr, cita_medicas.fecha as fecha, cita_medicas.tipo as tipo, cita_medicas.id as id").where(["pacientes_id = ? and inr_pacientes.fecha=cita_medicas.fecha", paciente.id])
        
      else
        @mensaje="No se encontro registro con esa especificacion"
      end
    else
      @especifico=false
      @pacientes=Paciente.all
    end
  end
  
end
