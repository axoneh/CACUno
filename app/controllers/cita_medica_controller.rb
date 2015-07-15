class CitaMedicaController < ApplicationController
  def crear
  end

  def aplicar
    unless validacionMedico() or validacionParamedico() #debe ser medico o paramedico para aplicar alguna cita medica
      redirect_to controller: "principal", action: "index"
      return
    end
    unless params[:paciente].present?#debe estar el correo del paciente como parametro y existir en la base de datos
      redirect_to controller: "principal", action: "index"
      return
    else
      unless Paciente.exists?(["correo = ?", params[:paciente]])
        redirect_to controller: "principal", action: "index"
        return
      end
    end
    correo=params[:paciente]
    citaActual = CitaMedica.new#creacion de la nueva cita medica
    citaActual.pacientes_id = Paciente.find_by(correo: correo).id
    citaActual.cuenta_usuarios_id = current_cuenta_usuario.id
    citaActual.fecha = Date.current
    citaActual.estado = 1
    citaActual.hora_ini = Time.now.strftime("%I:%M:%S")
    if validacionMedico()
      citaActual.tipo="Presencial"
    else
      citaActual.tipo="Domiciliaria"
    end
    #validaciones de existencia de citas previas
    if CitaMedica.exists?(["pacientes_id = ? and fecha = ? and hora_ini= ? ",citaActual.pacientes_id, citaActual.fecha, citaActual.hora_ini])
      flash.alert="El paciente tiene una cita para esta misma hora, verifique los datos"
    elsif CitaMedica.exists?(["cuenta_usuarios_id = ? and fecha = ? and hora_ini= ? ",citaActual.cuenta_usuarios_id, citaActual.fecha, citaActual.hora_ini])
      flash.alert="Usted no deberia guardar una cita para hoy a esa hora ya que tiene una cita con esas caracteristicas"
    else
      citaActual.save#de pasar los filtros, se guarda y redirecciona para efectuar la cita
      redirect_to controller:"cita_medica", action: "efectuar", cita: citaActual.id
    end
  end
#-------------------------------------------------------------------------------------------------------------------------
  def efectuar
    @nivel=true#booleano para saber si es la cita sera domiciliaria o presencial
    unless params[:cita].present? or CitaMedica.exists(["id = ?", params[:cita]])#validacion de existencia de parametros y de registro en la base de datos
      redirect_to controller: "principal", action: "index"
    end
    citaActual=CitaMedica.find(params[:cita])
    if RespuestaCita.exists?(["cita_medicas_id = ?",citaActual.id])#si ya existe respuesta se procede a cambiar el estado de la respuesta y a redireccionar a la visualizacion
      citaActual.estado=2
      citaActual.save
      redirect_to controller: "cita_medica", action: "visualizar", cita: citaActual.id
    end
    
    @anticoagulantes=Anticoagulante.where(["estado = ?",1])#consulta de anticoagulantes en uso actualmente
    
    if validacionMedico() and citaActual.tipo=="Presencial" #validacion para saber si es cita presencial  y si el usuario es medico
      
      @preguntas=Pregunta.where(["estado = ?", 1])
      @nivel=true
      @diasAsociados=DiaAsociado.where(["estado = ?", 1])
      
      if request.post?

        if params[:analisis].present? and params[:plan].present? and params[:subjetiva].present? and params[:objetiva].present? and params[:fecha_fin].present? and params[:inr].present?
          #validacion de existencia de parametros
          inrPac=InrPaciente.new#nuevo inr del paciente
          inrPac.cita_medicas_id=citaActual.id
          inrPac.anticoagulantes_id=params[:antic_inr]
          inrPac.fecha=citaActual.fecha
          inrPac.valorInr=params[:inr]
          inrPac.save
          
          respuesta=RespuestaCita.new#nueva respuesta, asignada a la cita actual
          respuesta.cita_medicas_id=citaActual.id
          respuesta.cuenta_usuarios_id=current_cuenta_usuario.id
          respuesta.analisis=params[:analisis]
          respuesta.plan=params[:plan]
          respuesta.estado=1
          respuesta.save
          
          observacion=ObservacionMedica.new#nueva observacion para la cita
          observacion.respuesta_cita_id=respuesta.id
          observacion.subjetivo=params[:subjetiva]
          observacion.objetivo=params[:objetiva]
          if params[:indefinido].present?
            observacion.tiempoIndefinido=true
          else
            observacion.tiempoIndefinido=false
            observacion.semanasTratamiento=params[:semanas_t]
          end
          observacion.save
          
          prescripcion=Prescripcion.new#nueva prescripcion para la respuesta medica
          prescripcion.anticoagulantes_id=params[:antic]
          prescripcion.respuesta_cita_id=respuesta.id
          prescripcion.fechaFin=params[:fecha_fin]
          prescripcion.save
          
          @preguntas.each do |t|#guardando las respuestas de la encuesta del paciente
            if params[t.id.to_s+"_p"].present?
              if t.tipo
                PreguntaCita.create(cita_medicas_id: citaActual.id, pregunta_id: t.id, comentario: params[t.id.to_s+"_comentario"])
              else
                PreguntaCita.create(cita_medicas_id: citaActual.id, pregunta_id: t.id)
              end
            end
          end
          
          @diasAsociados.each do |t|#guardando la prescripcion diaria del paciente
            if params[t.id.to_s+"_d"].present?
              PrescripcionDiaria.create(prescripcions_id: prescripcion.id, dia_asociados_id: t.id, cantidadGramos: params[t.id.to_s+"_cantidad"])
            end
          end
          
          citaActual.estado=2#actualizacion de la cita, para notificar que ya tiene respuesta
          citaActual.save()
          
          redirect_to controller: "cita_medica", action: "visualizar", cita: citaActual.id
          
        else#de no presentarce algun valor, se debe mantener los datos ya ingresados
          if params[:analisis].present?
            @valorAnalisis=params[:analisis]
          end  
          if params[:plan].present? 
            @valorPlan=params[:plan]
          end
          if params[:subjetiva].present?
            @valorSubjetiva=params[:subjetiva]
          end
          if params[:objetiva].present?
            @valorObjetiva=params[:objetiva]
          end
          if params[:fecha_fin].present?
            @valorFechaFin=params[:fecha_fin]
          end
          if params[:inr].present?
            @valorInt=params[:inr]
          end
          flash.alert="Debe diligenciar todos los campos de la respuesta"
        end
      end
    elsif validacionParamedico() and citaActual.tipo=="Domiciliaria"
      
      @preguntas=Pregunta.where(["estado = ? and tag <> 'inr dificil'", 1])
      @nivel=false
      
      if request.post?
        
        if params[:inr].present?
          
          inrPac=InrPaciente.new
          inrPac.cita_medicas_id=citaActual.id
          inrPac.anticoagulantes_id=params[:antic_inr]
          inrPac.fecha=citaActual.fecha
          inrPac.valorInr=params[:inr]
          inrPac.save
          
          citaActual.estado=3;
          citaActual.save
          
          @preguntas.each do |t|
            if params[t.id.to_s].present?
              if t.tipo
                PreguntaCita.create(cita_medicas_id: citaActual.id, pregunta_id: t.id, comentario: params[t.id.to_s+"_comentario"])
              else
                PreguntaCita.create(cita_medicas_id: citaActual.id, pregunta_id: t.id)
              end
            end
          end
          
          redirect_to controller: "cita_medica", action: "visualizar", cita: citaActual.id
        else
          flash.alert="Debe diligenciar el inr"
        end
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end
#------------------------------------------------------------------------------------------------------
  def modificar
  end
#------------------------------------------------------------------------------------------------------ 
  def visualizar
    @nivel=1#entero encargado de manejar que tipo de consulta sera: 3 para unica, 2 para notificaciones y 1 para general
    @encargado=validacionEncargadoRespuesta()
    if params[:cita].present? and CitaMedica.exists?(["id = ? ",params[:cita]])
      @nivel=3
      @cita=CitaMedica.find(params[:cita])
      @preguntas=PreguntaCita.joins(:pregunta).where(["cita_medicas_id= ?", @cita.id])
      @inr=InrPaciente.where(["fecha = ? and cita_medicas_id = ?", @cita.fecha, @cita.id]).first
      
      @respuesta=RespuestaCita.find_by(cita_medicas_id: @cita.id)#consulta de respuesta para la cita
      
      if @respuesta
        
        @observacion=ObservacionMedica.find_by(respuesta_cita_id: @respuesta.id)#consulta de la observacion medica
        
        @prescripcion=Prescripcion.find_by(respuesta_cita_id: @respuesta.id)#consulta de la prescripcion
        
      end
    elsif params[:notificacion].present? and params[:notificacion]#consulta de las citas sin responder
      unless @encargado
        redirect_to controller: "principal", action: "index"
      end
        @nivel=2
        @citasRegistradas=CitaMedica.where(["estado = ?", 3])
    else
      @nivel=1
      @citasRegistradas=CitaMedica.all
    end
  end
#------------------------------------------------------------------------------------------------------
  def agregar_respuesta
    unless validacionEncargadoRespuesta() and params[:cita].present? and CitaMedica.exists?(["id = ? and estado = ?", params[:cita], 3])
      redirect_to controller: "principal", action: "index"
    end
    
    cita=CitaMedica.find(params[:cita])
    
    if RespuestaCita.exists?(["cita_medicas_id = ?",cita.id])
      cita.estado=2
      cita.save
      redirect_to controller: "cita_medica", action: "visualizar", cita: cita.id
    end
    
    @diasAsociados=DiaAsociado.where(["estado = ?", 1])
    
    @anticoagulantes=Anticoagulante.where(["estado = ?", 1])
    
    @preguntaInr=Pregunta.where(["estado = 1 and tag = 'inr dificil'"]).first
    
    @inr=InrPaciente.where(["fecha = ? and cita_medicas_id = ?", cita.fecha, cita.id]).first

    if request.post?
      
      if params[:analisis].present? and params[:plan].present? and params[:fecha_fin].present?
        
        respuesta=RespuestaCita.new
        respuesta.cita_medicas_id=cita.id
        respuesta.cuenta_usuarios_id=current_cuenta_usuario.id
        respuesta.analisis=params[:analisis]
        respuesta.plan=params[:plan]
        respuesta.estado=1
        respuesta.save
        
        prescripcion=Prescripcion.new
        prescripcion.respuesta_cita_id=respuesta.id
        prescripcion.anticoagulantes_id=params[:antic]
        prescripcion.fechaFin=params[:fecha_fin]
        prescripcion.save
        
        @diasAsociados.each do |t|
          if params[t.id.to_s+"_d"].present?
            PrescripcionDiaria.create(dia_asociados_id: t.id, prescripcions_id: prescripcion.id, cantidadGramos: params[t.id.to_s+"_cantidad"])
          end
        end
        
        if params[@preguntaInr.id.to_s+"_p"].present?
          PreguntaCita.create(cita_medicas_id: cita.id, pregunta_id: @preguntaInr.id)
        end
        
        cita.estado=2
        cita.save
        
        redirect_to controller: "cita_medica", action: "visualizar", cita: cita.id
      else
        if params[:analisis].present? 
          @valorAnalisis=params[:analisis]
        end
        if params[:plan].present? 
          @valorPlan=params[:plan]
        end
        if params[:fecha_fin].present?
          @valorFechaFin=params[:fecha_fin]
        end
        flash.alert="Debe diligenciar todos los campos"
      end
    end
  end

end
