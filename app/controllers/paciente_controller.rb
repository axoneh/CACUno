class PacienteController < ApplicationController
  
  def agregar
    unless @admin or @medico
      redirect_to controller: "principal", action: "contenido"
    else
      @paciente=Paciente.new
      if agregacion()
        crear_cita_generica()
        redirect_to controller: "paciente", action: "agregar_inr", paciente: @paciente.correo
      end
    end
  end

  def actualizar
    unless @admin or @medico
      redirect_to controller: "principal", action: "contenido"
    else
      if params[:paciente].present? and Paciente.exists?(["correo = ? ",params[:paciente]])
        @paciente=Paciente.find_by(correo: params[:paciente])
        if params[:activar].present? and @admin
          @paciente.estado=1
          @paciente.save
          redirect_to controller: "paciente", action: "visualizar"
        elsif params[:desactivar].present? and @admin
          @paciente.estado=2
          @paciente.save
          redirect_to controller: "paciente", action: "visualizar"
        else
          if agregacion()
            redirect_to controller: "paciente", action: "visualizar", correo: @paciente.correo
          end
        end
      else
        redirect_to controller: "principal", action: "contenido"
      end
    end
  end
  
  def visualizar
    
    @especifico=false
    
    if params[:correo].present? and Paciente.exists?(["correo = ?", params[:correo]])
      
      @especifico=true
      
      @paciente=Paciente.find_by(correo: params[:correo])
      
      if @paciente.genero
        @genero="Masculino"
      else
        @genero="Femenino"
      end

      @edad=edad(@paciente.fecha_nacimiento.to_date)

      cita=CitaMedica.where(["pacientes_id = ? and estado = ? and generico = ?", @paciente.id, 2, false]).order("fecha").last
      
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
        sumaRiesgo=cita.observacion_medicas
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
      
      #riesgo hemorragico
      @riesgoHemorragia=0
      
      @riesgoHemorragia+=buscar_antecedente('antecedente renal')
      @riesgoHemorragia+=buscar_antecedente('antecedente hepatico')
      @riesgoHemorragia+=buscar_antecedente('ecv previo')
      @riesgoHemorragia+=buscar_antecedente('evento hemorragico')
      @riesgoHemorragia+=buscar_antecedente('farmaco')
      @riesgoHemorragia+=buscar_antecedente('alcohol')
      
      if cita
        sumaRiesgo=cita.observacion_medicas
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
      
      @citasMedicas=@paciente.cita_medicas.where(["generico = ? and estado > ?", false, 1])
      @InrPaciente=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ?",@paciente.id]).order("inr_pacientes.fecha desc")
      @InrPacienteG=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ?",@paciente.id]).group("inr_pacientes.fecha").order("inr_pacientes.fecha asc")
      rango_antic()
    else
      @especifico=false
      if @encargado or @admin
        @pacientesN=Paciente.joins(:cita_medicas).select("pacientes.*, cita_medicas.estado as estadoCita").where(["cita_medicas.estado= ? and pacientes.estado = ?",3,1]).group("cita_medicas.pacientes_id")
      end
      @pacientes=Paciente.joins(:cita_medicas).select("pacientes.*, cita_medicas.estado as estadoCita").group("cita_medicas.pacientes_id")
      if @medico or @paramedico
        @pacientes=@pacientes.where(["pacientes.estado=?",1])
      end
      if params[:busqueda].present?
        @pacientes=@pacientes.where(["CONCAT(pacientes.nombre,' ',pacientes.apellido) like ?", '%'+params[:busqueda]+'%'])
      end
    end
  end

  def agregar_inr
    unless @admin or @medico
      redirect_to controller: "principal", action: "contenido"
    else
      unless params[:paciente].present? and Paciente.exists?(["correo = ?", params[:paciente]])
        redirect_to controller: "principal", action: "contenido"
      else
        @paciente=Paciente.find_by(correo: params[:paciente])
        cita=@paciente.cita_medicas.where(["estado = ? and generico = ?", 2, true]).first
        unless cita
          crear_cita_generica()
          cita=@paciente.cita_medicas.where(["estado = ? and generico = ?", 2, true]).first
        end
        if cita
          if params[:inr].present? and params[:fecha_inr].present? and cita
            InrPaciente.create(cita_medicas_id: cita.id, valorInr: params[:inr].to_f, fecha: params[:fecha_inr])
          end
          if params[:inr_e].present? and InrPaciente.exists?(["id = ? and cita_medicas_id = ?", params[:inr_e], cita.id])
            InrPaciente.delete_all(["id = ?",params[:inr_e]])
          end
        end
        
        inrP=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ? and generico = ?",@paciente.id, true]).order("inr_pacientes.fecha asc").group("inr_pacientes.fecha").pluck("inr_pacientes.valorInr","inr_pacientes.fecha")
        @paciente.ttrCacPrevio=calcularTTR(inrP)
        @paciente.save()
        
        @InrPaciente=InrPaciente.joins(:cita_medicas).where(["cita_medicas.pacientes_id = ? and generico = ?",@paciente.id, true]).order("inr_pacientes.fecha desc")
        if params[:lab].present? and params[:rep].present? and params[:fecha_lab].present?
          Laboratorio.create(pacientes_id: @paciente.id, fecha: params[:fecha_lab], estudio: params[:lab], resultado: params[:rep], observacion: params[:observacion])
        end
        if params[:lab_d].present?
          Laboratorio.delete(params[:lab_d])
        end
      end
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
    sumaRiesgo=AntecedenteMedico.find_by(tag: nombre)
    if sumaRiesgo and AntecedentePaciente.exists?(["pacientes_id = ? and antecedente_medicos_id = ?", @paciente.id, sumaRiesgo.id])
      valor=1
    end
    return valor
  end

  def agregacion
    
    @antecedentesPaciente=AntecedentePaciente.where(["pacientes_id = ?", @paciente.id])
    @valorAntecedentes=@paciente.antecedente_general
    @valorApellido=@paciente.apellido
    @valorCorreo=@paciente.correo
    @valorDireccion=@paciente.direccion
    @valorFechaN=@paciente.fecha_nacimiento
    @valorIdentificacion=@paciente.identificacion
    @valorNombre=@paciente.nombre
    @valorTelefono=@paciente.telefono
    
    @ciudades=Ciudad.where(["estado = ?", 1])
    @antecedentes=AntecedenteMedico.where(["estado = ? ", 1])    
    @documentos=TipoDocumento.where(["estado = ?", 1])
    @estadosC=EstadoCivil.where(["estado = ?", 1])
    @patologias=Patologia.where(["estado = ?", 1])
    
    if request.post?
      if params[:correo].present? and params[:nombre].present? and params[:apellido].present? and params[:identificacion].present? and params[:fecha_n].present? and params[:direccion].present? and params[:telefono].present?
        correo=params[:correo]
        ident=params[:identificacion]
        documento=params[:documento]
        
        if Paciente.exists?(["correo = ? and id <> ?",correo, @paciente.id])
          flash.alert="Ya existe ese correo registrado, por favor verifique los datos"
        elsif Paciente.exists?(["identificacion = ? and tipo_documentos_id = ? and id <> ?", ident, documento, @paciente.id])
          flash.alert="Ya existe un usuario con ese numero de identificacion y documento, verifique los datos"
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
          @paciente.telefono=params[:telefono]
          @paciente.ciudads_id=params[:ciudad]
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
          return true
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
        if params[:telefono].present?
          @valorTelefono=params[:telefono]
        end
        flash.alert="Debe diligenciar todos los campos"
        return false
      end
    end
  end
  
  def crear_cita_generica
    unless @paciente.cita_medicas.exists?(["generico = ?",true])
      cita = CitaMedica.new
      cita.pacientes_id = @paciente.id
      cita.cuenta_usuarios_id = current_cuenta_usuario.id
      cita.fecha = Date.current
      cita.estado = 2
      t=Time.zone.now
      cita.hora_ini = t.hour.to_s+ ":"+t.min.to_s+": "+t.sec.to_s
      cita.tipo="Presencial"
      cita.generico=true
      cita.save()
    end
  end
  
end
