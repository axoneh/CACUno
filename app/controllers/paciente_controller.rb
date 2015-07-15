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
    unless validacionAdmin()
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
        
        documento=TipoDocumento.find(paciente.tipo_documentos_id)
        @documento=documento.nombre
        
        @direccion=paciente.direccion
        
        @genero="(Sin cargar)"
        if paciente.genero
          @genero="Masculino"
        else
          @genero="Femenino"
        end

        estadoC=EstadoCivil.find(paciente.estado_civils_id)
        @estadoC=estadoC.nombre
        
        patologia=Patologia.find(paciente.patologia_id)
        @patologia=patologia.nombre
        @desPatologia=patologia.descripcion
        @fechaN=paciente.fecha_nacimiento
        @edad=edad(@fechaN.to_date)
        
        if CitaMedica.exists?(["pacientes_id = ? and estado= ?", paciente.id,2])
          @fechaPrimera=CitaMedica.where(["pacientes_id = ? and estado= ?", paciente.id,2]).order(:fecha).first.fecha
        end
        
        if @fechaPrimera
          @promedioINR=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ? and inr_pacientes.fecha >= ?", paciente.id, @fechaPrimera]).average(:valorInr)                                          
          cantidadInr=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ? and inr_pacientes.fecha >= ?", paciente.id, @fechaPrimera]).count
          if cantidadInr>0
            cantidadInrBien=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ? and inr_pacientes.fecha >= ? and inr_pacientes.valorInr>= 2.5 and inr_pacientes.valorInr<=3.5", paciente.id, @fechaPrimera]).count
            @porcentajeINR=(cantidadInrBien * 100)/cantidadInr
          end
        end
        
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
        
        #Riesgo de embolia
        @riesgoEmbolia=0
        
        sumaRiesgo=AntecedenteMedico.find_by(tag: 'insuficiencia cardiaca')#si el paciente tiene insuficiencia cardiaca
        if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", paciente.id, sumaRiesgo.id])
          @riesgoEmbolia+=1
        end
        sumaRiesgo=AntecedenteMedico.find_by(tag: 'hipertension')#si el paciente tiene hipertension
        if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", paciente.id, sumaRiesgo.id])
          @riesgoEmbolia+=1
        end
        sumaRiesgo=AntecedenteMedico.find_by(tag: 'diabetes')#si el paciente tiene diabetes
        if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", paciente.id, sumaRiesgo.id])
          @riesgoEmbolia+=1
        end
        sumaRiesgo=AntecedenteMedico.find_by(tag: 'antecedente trombolico')#antecedente trombolico en el paciente
        if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", paciente.id, sumaRiesgo.id])
          @riesgoEmbolia+=2
        end
        if cita
          sumaRiesgo=Pregunta.find_by(tag: 'enfermedad vascular')#si el paciente tiene alguna enfermedad cardio vascular
          if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
            @riesgoEmbolia+=1
          end
        end
        unless paciente.genero#genero del paciente
          @riesgoEmbolia+=1
        end
        sumaRiesgo=edad(@fechaN.to_date)#edad del paciente
        if sumaRiesgo>64
          @riesgoEmbolia+=1
          if sumaRiesgo>74
            @riesgoEmbolia+=2
          end
        end
        
        @riesgoEmbolia=@riesgoEmbolia * 10
        
        #riesgo hemorragico
        @riesgoHemorragia=0
        sumaRiesgo=AntecedenteMedico.find_by(tag: 'hipertension')#si el paciente tiene hipertension
        if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", paciente.id, sumaRiesgo.id])
          @riesgoHemorragia+=1
        end
        if cita
          sumaRiesgo=Pregunta.find_by(tag: 'alteracion renal')#alguna alteracion renal
          if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
            @riesgoHemorragia+=1
          end
          sumaRiesgo=Pregunta.find_by(tag: 'alteracion hepatica')#alguna alteracion hepatica
          if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
            @riesgoHemorragia+=1
          end
          sumaRiesgo=Pregunta.find_by(tag: 'evc previo')#evc previo
          if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
            @riesgoHemorragia+=1
          end
          sumaRiesgo=Pregunta.find_by(tag: 'sangrado oral')#evc previo
          if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
            @riesgoHemorragia+=1
          end
          sumaRiesgo=Pregunta.find_by(tag: 'inr dificil')#evc previo
          if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
            @riesgoHemorragia+=1
          end
          sumaRiesgo=Pregunta.find_by(tag: 'nuevos farmacos')#algun nuevo farmaco que tome el paciente y que interfiera con el anticoagulante
          if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
            @riesgoHemorragia+=1
          end
          sumaRiesgo=Pregunta.find_by(tag: 'alcohol')#alcohol
          if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
            @riesgoHemorragia+=1
          end
          sumaRiesgo=edad(@fechaN.to_date)
          if sumaRiesgo>74
            @riesgoHemorragia+=1
          end
        end
        
        @riesgoHemorragia=@riesgoHemorragia*100/9
        
      else
        @mensaje="No se encontro registro con esa especificacion"
      end
    else
      @especifico=false
      @pacientes=Paciente.all
    end
  end 
  
  private
  
  def edad( fecha)
    hoy = Date.current.to_date
    edad = hoy.year - fecha.year
    edad -= 1 if(hoy.yday < fecha.yday)
    edad
  end
  
end
