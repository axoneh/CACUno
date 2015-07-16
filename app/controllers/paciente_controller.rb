class PacienteController < ApplicationController
  
  def agregar
    unless validacionAdmin() or validacionMedico()
      redirect_to controller: "principal", action: "index"
    end
      
    @documentos=TipoDocumento.where(["estado = ?", 1])
    @estadosC=EstadoCivil.where(["estado = ?", 1])
    @patologias=Patologia.where(["estado = ?", 1])
    @antecedentes=AntecedenteMedico.where(["estado = ? ", 1])
      
    if request.post?
      if params[:correo].present? and params[:nombre].present? and params[:apellido].present? and params[:identificacion].present? and params[:fecha_n].present? and params[:direccion].present?
        correo=params[:correo]
        ident=params[:identificacion]
        documento=params[:documento]
        
        nombre=params[:nombre]
        apellido=params[:apellido]
        direccion=params[:direccion]
        genero=params[:genero]
        estadoC=params[:estadoC]
        patologia=params[:patologia]
        fechaN=params[:fecha_n]
        if Paciente.exists?(["correo = ?",correo])
          flash.alert="Ya existe ese correo registrado, por favor verifique los datos"
        elsif Paciente.exists?(["identificacion = ? and tipo_documentos_id = ?", ident, documento])
          flash.alert="Ya existe un usuario con ese documento, verifique los datos"
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
          flash.notice="Agregado exitoso de paciente"
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
      else
        if params[:correo].present?
          @valorCorreo=params[:correo]
        end
        if params[:nombre].present?
          @valorNombre=params[:nombre]
        end
        if params[:apellido].present?
          @valorApellido=params[:apellido]
        end  
        if params[:identificacion].present?
          @valorIdentificacion=params[:identificacion]
        end  
        if params[:direccion].present?
          @valorDireccion=params[:direccion]
        end
        if params[:fecha_n].present?
          @valorFechaN=params[:fecha_n]
        end
        flash.alert="Debe diligenciar todos los campos"
      end
    end
  end

  def actualizar
    unless validacionAdmin()
      redirect_to controller: "principal", action: "index"
    end
  end
  
  def visualizar
    
    @especifico=false
    @medico=validacionMedico()
    @paramedico=validacionParamedico()
    
    if params[:correo].present? and Paciente.exists?(["correo = ?", params[:correo]])
      
      @especifico=true
      
      @paciente=Paciente.find_by(correo: params[:correo])
      
      @fechaActual=Date.current
      
      if @paciente.genero
        @genero="Masculino"
      else
        @genero="Femenino"
      end

      @edad=edad(@paciente.fecha_nacimiento.to_date)
      
      if CitaMedica.exists?(["pacientes_id = ? and estado= ?", @paciente.id,2])
        @fechaPrimera=CitaMedica.where(["pacientes_id = ? and estado= ?", @paciente.id,2]).order(:fecha).first.fecha
      end
      
      if @fechaPrimera
          @promedioINR=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ? and inr_pacientes.fecha >= ?", @paciente.id, @fechaPrimera]).average(:valorInr)                                          
          cantidadInr=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ? and inr_pacientes.fecha >= ?", @paciente.id, @fechaPrimera]).count
          if cantidadInr>0
            cantidadInrBien=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ? and inr_pacientes.fecha >= ? and inr_pacientes.valorInr>= 2.5 and inr_pacientes.valorInr<=3.5", @paciente.id, @fechaPrimera]).count
            @porcentajeINR=(cantidadInrBien * 100)/cantidadInr
          end
        end
      
      cita=CitaMedica.where(["pacientes_id = ?", @paciente.id]).order(fecha: :desc).first
      
      if cita
        
        @inr=InrPaciente.where(["cita_medicas_id = ? and fecha = ?", cita.id, cita.fecha]).first
        
        @respuesta=RespuestaCita.find_by(cita_medicas_id: cita.id)
        if @respuesta
          @prescripcion=Prescripcion.find_by(respuesta_cita_id: @respuesta.id)
        end
        
      end
      
      #Riesgo de embolia
      @riesgoEmbolia=0
      
      sumaRiesgo=AntecedenteMedico.find_by(tag: 'insuficiencia cardiaca')#si el paciente tiene insuficiencia cardiaca
      if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", @paciente.id, sumaRiesgo.id])
        @riesgoEmbolia+=1
      end
      sumaRiesgo=AntecedenteMedico.find_by(tag: 'hipertension')#si el paciente tiene hipertension
      if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", @paciente.id, sumaRiesgo.id])
        @riesgoEmbolia+=1
      end
      sumaRiesgo=AntecedenteMedico.find_by(tag: 'diabetes')#si el paciente tiene diabetes
      if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", @paciente.id, sumaRiesgo.id])
        @riesgoEmbolia+=1
      end
      sumaRiesgo=AntecedenteMedico.find_by(tag: 'antecedente trombolico')#antecedente trombolico en el paciente
      if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", @paciente.id, sumaRiesgo.id])
        @riesgoEmbolia+=2
      end
      if cita
        sumaRiesgo=Pregunta.find_by(tag: 'enfermedad vascular')#si el paciente tiene alguna enfermedad cardio vascular
        if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
          @riesgoEmbolia+=1
        end
      end
      unless @paciente.genero#genero del paciente
        @riesgoEmbolia+=1
      end
      sumaRiesgo=edad(@paciente.fecha_nacimiento.to_date)#edad del paciente
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
      if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", @paciente.id, sumaRiesgo.id])
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
        sumaRiesgo=edad(@paciente.fecha_nacimiento.to_date)
        if sumaRiesgo>74
          @riesgoHemorragia+=1
        end
      end
      
      @riesgoHemorragia=@riesgoHemorragia*100/9
      
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
