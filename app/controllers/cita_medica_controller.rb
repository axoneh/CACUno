class CitaMedicaController < ApplicationController
  
  def crear
  end
#------------------------------------------------------------------------------------------------------
  def modificar
    
    unless @admin and params[:cita].present? and CitaMedica.exists?(["id = ? and estado = ?", params[:cita], 3])
      redirect_to controller: "principal", action: "index"
    else
      @cita=CitaMedica.find(params[:cita])
    end
  end
#------------------------------------------------------------------------------------------------------ 
  def visualizar
    @nivel=true
    if params[:cita].present? and CitaMedica.exists?(["id = ? ",params[:cita]])
      @cita=CitaMedica.find(params[:cita])
      if @cita.estado>1 and @cita.generico==false
        @nivel=true
        if @cita.cuenta_usuarios_id==current_cuenta_usuario.id
          @medicoC=true        
        end
        @paciente=@cita.pacientes
        @preguntas=@cita.pregunta_cita
        @respuesta=RespuestaCita.find_by(cita_medicas_id: @cita.id)
        if @respuesta
          @prescripcion=Prescripcion.find_by(respuesta_cita_id: @respuesta.id)
        end
      else
        redirect_to controller: "cita_medica", action: "visualizar"
      end
    elsif params[:usuario].present? and CuentaUsuario.exists?(["email = ?", params[:usuario]]) and (@medico or @paramedico)
      @titulo="Citas medicas del paciente"
      @nivel=false
      usuario=CuentaUsuario.find_by(email: params[:usuario])
      @citasRegistradas=CitaMedica.where(["cuenta_usuarios_id = ? and generico = ?", usuario.id, false]).order(:estado, fecha: :desc).group("pacientes_id")
    else
      @titulo="Citas medicas registradas"
      @nivel=false
      @citasRegistradas=CitaMedica.where(["generico = ?", false]).order(:estado).order(fecha: :desc)
      if params[:domiciliaria].present?
        @citasRegistradas=@citasRegistradas.where(["tipo = ?", 'Domiciliaria'])
        @titulo="Visitas domiciliarias registradas"
      elsif params[:presencial].present?
        @citasRegistradas=@citasRegistradas.where(["tipo = ?", 'Presencial'])
        @titulo="Consultas con especialista"
      end
    end
  end
#------------------------------------------------------------------------------------------------------
  def agregar_respuesta
    unless @encargado and params[:cita].present? and CitaMedica.exists?(["id = ? and estado > ?", params[:cita], 1])
      redirect_to controller: "principal", action: "contenido"
    else   
      @cita=CitaMedica.find(params[:cita])
      if RespuestaCita.exists?(["cita_medicas_id = ?",@cita.id])
        @cita.estado=2
        @cita.save
        redirect_to controller: "cita_medica", action: "visualizar", cita: @cita.id
      else
        @paciente=@cita.pacientes
        rango_antic()
        agregar_icd()
        @medicoC=true
        @diasAsociados=DiaAsociado.where(["estado = ?", 1])
        @anticoagulantes=Anticoagulante.where(["estado = ?", 1])
        @preguntaInr=Pregunta.where(["estado = 1 and tag = 'inr dificil'"]).first
        if request.post?
          if params[:analisis].present? and params[:plan].present? and params[:fecha_fin].present? and params[:valor_min].present? and params[:valor_max].present?
            guardado_general()
            if params[@preguntaInr.id.to_s+"_p"].present?
              PreguntaCita.create(cita_medicas_id: @cita.id, pregunta_id: @preguntaInr.id)
            end
            @cita.estado=2
            @cita.save
            redirect_to controller: "cita_medica", action: "visualizar", cita: @cita.id
          else
            if params[:valor_max].present?
              @valorMax=params[:valor_max]
            end
            if params[:valor_min].present?
              @valorMin=params[:valor_min]
            end
            if params[:analisis].present? 
              @valorAnalisis=params[:analisis]
            end
            if params[:plan].present? 
              @valorPlan=params[:plan]
            end
            if params[:fecha_fin].present?
              @valorFechaFin=params[:fecha_fin]
            end
            if params[:recomendacion].present?
              @valorRecomendacion=params[:recomendacion]
            end
            flash.alert="Debe diligenciar todos los campos"
          end
        end
      end
    end
  end
#-----------------------------------------------------------------------------------------------------------------
  def efectuar
    unless @medico or @paramedico
      redirect_to controller: "principal", action: "index"
    else
      if params[:paciente].present? and Paciente.exists?(["correo = ?", params[:paciente]])
        paciente=Paciente.find_by(correo: params[:paciente])
        ultimaCita=paciente.ultimaCita()
        if (@paramedico and ultimaCita) or @medico
          fechaActual=Date.current
          else
            citaActual = CitaMedica.new
            citaActual.pacientes_id = paciente.id
            citaActual.cuenta_usuarios_id = current_cuenta_usuario.id
            citaActual.fecha = fechaActual
            citaActual.estado = 1
            citaActual.hora_ini = Time.now.strftime("%I:%M:%S")
            if @medico
              citaActual.tipo="Presencial"
            else
              citaActual.tipo="Domiciliaria"
            end
            citaActual.save
            redirect_to controller:"cita_medica", action: "efectuar", cita: citaActual.id
          end
        else
          flash.alert="No tiene registro de alguna cita presencial como remanente de la cita domiciliaria"
          redirect_to controller: "paciente", action: "visualizar"
        end
      elsif params[:cita].present? and CitaMedica.exists?(["id = ?", params[:cita]])
        @cita=CitaMedica.find(params[:cita])
        if current_cuenta_usuario.id!=@cita.cuenta_usuarios_id
          redirect_to controller: "cita_medica", action: "visualizar"
        elsif RespuestaCita.exists?(["cita_medicas_id = ?",@cita.id])
          @cita.estado=2
          @cita.save
          redirect_to controller: "cita_medica", action: "visualizar", cita: @cita.id
        else
          agregar_icd()
          @paciente=@cita.pacientes
          @anticoagulantes=Anticoagulante.where(["estado = ?",1])
          if @medico and @cita.tipo=="Presencial"
            @medicoC=true
            rango_antic()
            @nivel=true
            @diasAsociados=DiaAsociado.where(["estado = ?", 1])
            @antecedentes=AntecedenteMedico.where(["estado = ? ", 1])
            if params[:cambio_i].present?
              @cambio=true
              @antecedentesPaciente=AntecedentePaciente.where(["pacientes_id = ?", @paciente.id])
            end
            if params[:cambio_t].present?
              @cambio=false
              AntecedentePaciente.delete_all(["pacientes_id = ?", @paciente.id])
              @antecedentes.each do |a|
                if params[a.id.to_s].present?
                  AntecedentePaciente.create(pacientes_id: @paciente.id, antecedente_medicos_id: a.id, comentario: params[a.id.to_s+"_comentario"])
                end
              end
            end
            if request.post?
              if params[:analisis].present? and params[:plan].present? and params[:subjetiva].present? and params[:objetiva].present? and params[:fecha_fin].present? and params[:inr].present? and params[:valor_min].present? and params[:valor_max].present? and params[:hsis].present? and params[:hdia].present? and params[:frecuencia_car].present?
                guardar_inr()
                guardado_general()
                guardar_observacion()
                @cita.estado=2#actualizacion de la cita, para notificar que ya tiene respuesta
                @cita.fecha_realizacion=Date.current
                @cita.save()
                flash.notice="Cita concluida exitosamente"
                redirect_to controller: "cita_medica", action: "visualizar", cita: @cita.id
              else
                flash.alert="Debe diligenciar todos los campos de la respuesta"
              end
            end
          elsif @paramedico and @cita.tipo=="Domiciliaria"
            @preguntas=Pregunta.where(["estado = ? and tag <> 'inr dificil'", 1])
            @nivel=false
            @ultimaCita=@paciente.cita_medicas.where(["generico = ? and estado = ? and tipo = ?", false, 2, 'Presencial']).last
            if request.post?
              if params[:inr].present? and params[:hsis].present? and params[:hdia].present? and params[:frecuencia_car].present? and params[:observacion].present?
                guardar_inr()
                guardar_preguntas()
                guardar_observacion()
                @cita.estado=3;
                @cita.fecha_realizacion=Date.current
                @cita.save
                flash.notice="Cita realizada exitosamente, en espera de respuesta"
                redirect_to controller: "cita_medica", action: "visualizar", cita: @cita.id
              else
                flash.alert="Debe diligenciar todos los campos"
              end
            end  
          else
            redirect_to controller: "principal", action: "contenido"
          end
        end
      else
        redirect_to controller: "principal", action: "contenido"
      end
    end
  end

private

  def guardar_preguntas
    @preguntas.each do |t|#guardando las respuestas de la encuesta del paciente
      if params[t.id.to_s].present?
        PreguntaCita.create(cita_medicas_id: @cita.id, pregunta_id: t.id, comentario: params[t.id.to_s+"_comentario"])
      end
    end
  end

  def agregar_icd
    if params[:icd_b].present?
      @icd_b=Icd.where(["CONCAT(id10,' ',dec10) like ?", '%'+params[:icd_b]+'%'])
    end
    if params[:icd_v].present? and Icd.exists?(["id = ?", params[:icd_v]])
      unless CitaIcd.exists?(["icds_id = ? and  cita_medicas_id = ?",params[:icd_v],@cita.id])
        CitaIcd.create(icds_id: params[:icd_v], cita_medicas_id: @cita.id)
      end
    end
    if params[:icd_e].present?
      CitaIcd.delete_all(["id = ?", params[:icd_e]])
    end
  end

  def guardar_observacion
    observacion=ObservacionMedica.new
    observacion.cita_medicas_id=@cita.id
    observacion.frecuencia_cardiaca=params[:frecuencia_car]
    observacion.hiper_sistolica=params[:hsis]
    observacion.hiper_diastolica=params[:hdia]
    if @medico
      observacion.obDos=params[:subjetiva]
      observacion.obUno=params[:objetiva]
      if params[:temporal].present?
        observacion.tiempoIndefinido=false
        observacion.diasTratamiento=params[:semanas_t].to_i * 7
      else
        observacion.tiempoIndefinido=true
      end
    elsif @paramedico
      observacion.obUno=params[:observacion]
    end
    observacion.save
  end

  def guardado_general
    respuesta=RespuestaCita.new
    respuesta.cita_medicas_id=@cita.id
    respuesta.cuenta_usuarios_id=current_cuenta_usuario.id
    respuesta.analisis=params[:analisis]
    respuesta.plan=params[:plan]
    respuesta.estado=1
    respuesta.valor_min=params[:valor_min]
    respuesta.valor_max=params[:valor_max]
    respuesta.save
    
    prescripcion=Prescripcion.new
    prescripcion.respuesta_cita_id=respuesta.id
    prescripcion.anticoagulantes_id=params[:antic]
    prescripcion.fechaFin=(Time.now + params[:fecha_fin].to_i.day).to_date
    prescripcion.recomendacion=params[:recomendacion]
    prescripcion.save
    
    @diasAsociados.each do |t|
      if params[t.id.to_s].present?
        PrescripcionDiaria.create(dia_asociados_id: t.id, prescripcions_id: prescripcion.id, cantidadGramos: params[t.id.to_s+"_cantidad"].to_f)
      end
    end
    
  end
  
  def guardar_inr
    inrPac=InrPaciente.new
    inrPac.cita_medicas_id=@cita.id
    inrPac.fecha=Date.current
    inrPac.valorInr=params[:inr].to_f
    inrPac.save
  end

  def rango_antic
    @valorMax=3
    @valorMin=2
    @ultimaCita=@paciente.cita_medicas.where(["generico = ? and estado = ?", false, 2]).last
    if @ultimaCita
      @valorMax=@ultimaCita.respuesta_cita.valor_max
      @valorMin=@ultimaCita.respuesta_cita.valor_min
    end
  end

end