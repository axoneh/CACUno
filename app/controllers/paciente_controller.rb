class PacienteController < ApplicationController
  
  def agregar_inr
    
  end
  
  def agregar
    unless validacionAdmin() or validacionMedico()
      redirect_to controller: "principal", action: "index"
    end

    @paciente=Paciente.new
    @accion="agregar"
    
    agregacion()
    
    cita = CitaMedica.new
    cita.pacientes_id = @paciente.id
    cita.cuenta_usuarios_id = current_cuenta_usuario.id
    cita.fecha = Date.current
    cita.estado = 1
    cita.hora_ini = Time.now.strftime("%I:%M:%S")
    cita.tipo="Domiciliaria"
    cita.generico=true
    cita.save()
  end

  def actualizar
    unless validacionAdmin() or validacionMedico()
      redirect_to controller: "principal", action: "index"
    end
    
    @paciente=Paciente.find_by(correo: params[:paciente])
    @accion="actualizar"
    
    agregacion()
    
  end
  
  def visualizar
    
    @especifico=false
    @medico=validacionMedico()
    @paramedico=validacionParamedico()
    @admin=validacionAdmin()
    
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
      
      cita=CitaMedica.where(["pacientes_id = ? and estado = ?", @paciente.id, 2]).order("fecha").last
      
      if cita
        
        @inr=InrPaciente.where(["cita_medicas_id = ? and fecha = ?", cita.id, cita.fecha]).first
        
        @respuesta=RespuestaCita.find_by(cita_medicas_id: cita.id)
        if @respuesta
          @prescripcion=Prescripcion.find_by(respuesta_cita_id: @respuesta.id)
        end
        
      end
      
      #Riesgo de embolia
      @riesgoEmbolia=0
      @riesgoEmbolia+=buscar_antecedente('insuficiencia cardiaca');
      @riesgoEmbolia+=buscar_antecedente('diabetes');
      @riesgoEmbolia+=(buscar_antecedente('ecv previo'))*2;
      @riesgoEmbolia+=buscar_antecedente('enfermedad vascular');
      
      if cita
        sumaRiesdo=cita.respuesta_cita.first.observacion_medicas.first
        if sumaRiesgo and (sumaRiesgo.hiper_sistolica>160 or sumaRiesgo.hiper_diastolica>100)
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
      
      @riesgoHemorragia+=buscar_antecedente('antecedente renal')
      @riesgoHemorragia+=buscar_antecedente('antecedente hepatico')
      @riesgoHemorragia+=buscar_antecedente('ecv previo')
      @riesgoHemorragia+=buscar_antecedente('evento hemorragico')
      @riesgoHemorragia+=buscar_antecedente('farmaco')
      @riesgoHemorragia+=buscar_antecedente('alcohol')
      
      if cita
        sumaRiesdo=cita.respuesta_cita.first.observacion_medicas.first
        if sumaRiesgo and (sumaRiesgo.hiper_sistolica>160 or sumaRiesgo.hiper_diastolica>100)
          @riesgoEmbolia+=1
        end
        sumaRiesgo=Pregunta.find_by(tag: 'inr dificil')#evc previo
        if sumaRiesgo and PreguntaCita.exists?(["cita_medicas_id = ? and pregunta_id = ?", cita.id, sumaRiesgo.id])
          @riesgoHemorragia+=1
        end
      end
      
      sumaRiesgo=edad(@paciente.fecha_nacimiento.to_date)
      if sumaRiesgo>74
        @riesgoHemorragia+=1
      end
      
      @riesgoHemorragia=@riesgoHemorragia*100/9
      
      @citasMedicas=@paciente.cita_medicas.where(["estado = ? and generico = ?", 2, false])
      @InrPrevio=@paciente.cita_medicas.where(["generico = ?",true]).first.inr_pacientes
      
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
  
  def buscar_antecedente( nombre)
    valor=0
    sumaRiesgo=AntecedenteMedico.find_by(tag: nombre)#si el paciente tiene diabetes
    if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", @paciente.id, sumaRiesgo.id])
      valor=1
    end
    return valor
  end
  
private  
  
  def agregacion
    
    @valorAntecedentes=@paciente.antecedente_general
    @valorApellido=@paciente.apellido
    @valorCorreo=@paciente.correo
    @valorDireccion=@paciente.direccion
    @valorFechaN=@paciente.fecha_nacimiento
    @valorIdentificacion=@paciente.identificacion
    @valorNombre=@paciente.nombre
    
    @antecedentes=AntecedenteMedico.where(["estado = ? ", 1])    
    @documentos=TipoDocumento.where(["estado = ?", 1])
    @estadosC=EstadoCivil.where(["estado = ?", 1])
    @patologias=Patologia.where(["estado = ?", 1])
    
    if request.post?
      if params[:correo].present? and params[:nombre].present? and params[:apellido].present? and params[:identificacion].present? and params[:fecha_n].present? and params[:direccion].present?
        correo=params[:correo]
        ident=params[:identificacion]
        documento=params[:documento]
        
        if Paciente.exists?(["correo = ? and id <> ?",correo, @paciente.id])
          flash.alert="Ya existe ese correo registrado, por favor verifique los datos"
        elsif Paciente.exists?(["identificacion = ? and tipo_documentos_id = ? and id <> ?", ident, documento, @paciente.id])
          flash.alert="Ya existe un usuario con ese documento, verifique los datos"
        else
          
          @paciente.correo=correo
          @paciente.identificacion=ident
          @paciente.tipo_documentos_id=documento
          @paciente.fecha_nacimiento=params[:fecha_n]
          @paciente.nombre=params[:nombre]
          @paciente.apellido=params[:apellido]
          @paciente.direccion=params[:direccion]
          @paciente.genero=params[:genero]
          @paciente.estado_civils_id=params[:estadoC]
          @paciente.patologia_id=params[:patologia]
          @paciente.estado=1
          @paciente.antecedente_general=params[:antecedentes]
          if params[:avatar].present?
            @paciente.avatar=params[:avatar]
          end
          @paciente.save
          

          
          AntecedentePaciente.delete_all(["pacientes_id = ?", @paciente.id])
          
          @antecedentes.each do |a|
            if params[a.id.to_s].present?
              if a.tipo
                AntecedentePaciente.create(pacientes_id: @paciente.id, antecedente_medicos_id: a.id, comentario: params[a.id.to_s+"_comentario"])
              else
                AntecedentePaciente.create(pacientes_id: @paciente.id, antecedente_medicos_id: a.id)
              end
            end  
          end
          flash.notice="Agregado exitoso de paciente"
          if @accion=="actualizar"
            flash.notice="Actualizado exitosamente"
            redirect_to controller: "paciente", action: "visualizar", correo: @paciente.correo
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
        if params[:antecedentes].present?
          @valorAntecedentes=params[:antecedentes]
        end
        flash.alert="Debe diligenciar todos los campos"
      end
    end
  end
  
end
