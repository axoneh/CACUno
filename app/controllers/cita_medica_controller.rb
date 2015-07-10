class CitaMedicaController < ApplicationController
  def crear
  end

  def aplicar
    @mensaje=""
    if validacionMedico() or validacionParamedico()
      correop=params[:paciente]
      if correop
        paciente=Paciente.find_by(correo: correop)
        citaActual=CitaMedica.new
        citaActual.pacientes_id=paciente.id
        citaActual.cuenta_usuarios_id=current_cuenta_usuario.id
        citaActual.fecha=Date.current
        citaActual.estado = 1
        citaActual.hora_ini=Time.now.strftime("%I:%M:%S")
        if validacionMedico()
          citaActual.tipo="Presencial"
        else
          citaActual.tipo="Domiciliaria"
        end
        if CitaMedica.exists?(["pacientes_id = ? and fecha = ? and hora_ini= ? ",citaActual.pacientes_id, citaActual.fecha, citaActual.hora_ini])
          @mensaje="El paciente tiene una cita para esta misma hora, verifique los datos"
        elsif CitaMedica.exists?(["cuenta_usuarios_id = ? and fecha = ? and hora_ini= ? ",citaActual.cuenta_usuarios_id, citaActual.fecha, citaActual.hora_ini])
          @mensaje="Usted no deberia guardar una cita para hoy a esa hora ya que tiene una cita con esas caracteristicas"
        else
          citaActual.save()
          redirect_to controller:"cita_medica", action: "efectuar", cita: citaActual.id
        end
      else
        redirect_to controller: "principal", action: "index"
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def efectuar
    @nivel=true
    @mensaje=""
    if params[:cita].present?
      if CitaMedica.exists?(["id = ?", params[:cita]])
        citaActual=CitaMedica.find(params[:cita])
        if citaActual.estado!=1
          redirect_to controller: "principal", action: "index"
        end
        @preguntas=Pregunta.where(["estado = ?", 1])
        if validacionMedico()
          if citaActual.tipo=="Presencial"
            @nivel=true
            @anticoagulantes=Anticoagulante.where(["estado = ?",1])
            @diasAsociados=DiaAsociado.where(["estado = ?", 1])
            if request.post?
              PreguntaCita.delete_all(["cita_medicas_id = ?", citaActual.id])
              @preguntas.each do |t|
                if params[t.id.to_s+"_p"].present?
                  if t.tipo
                    PreguntaCita.create(cita_medicas_id: citaActual.id, pregunta_id: t.id, comentario: params[t.id.to_s+"_comentario"])
                  else
                    PreguntaCita.create(cita_medicas_id: citaActual.id, pregunta_id: t.id)
                  end
                end
              end
              if RespuestaCita.exists?(["cita_medicas_id = ?",citaActual.id])
                @mensaje="No se puede agregar respuesta porque ya existe una para esta cita"
              elsif params[:analisis].present? and params[:plan].present? and params[:subjetiva].present? and params[:objetiva].present? and params[:fecha_fin].present? and params[:inr].present?
                inrPac=InrPaciente.new
                inrPac.cita_medicas_id=citaActual.id
                inrPac.anticoagulantes_id=params[:antic_inr]
                inrPac.fecha=citaActual.fecha
                inrPac.valorInr=params[:inr]
                inrPac.save
                
                respuesta=RespuestaCita.new()
                respuesta.cita_medicas_id=citaActual.id
                respuesta.cuenta_usuarios_id=current_cuenta_usuario.id
                respuesta.analisis=params[:analisis]
                respuesta.plan=params[:plan]
                respuesta.estado=1
                respuesta.save()
                
                observacion=ObservacionMedica.new()
                observacion.respuesta_cita_id=respuesta.id
                observacion.subjetivo=params[:subjetiva]
                observacion.objetivo=params[:objetiva]
                if params[:indefinido].present?
                  observacion.tiempoIndefinido=true
                else
                  observacion.tiempoIndefinido=false
                  observacion.semanasTratamiento=params[:semanas_t]
                end
                observacion.save()
                
                prescripcion=Prescripcion.new()
                prescripcion.anticoagulantes_id=params[:antic]
                prescripcion.respuesta_cita_id=citaActual.id
                prescripcion.fechaFin=params[:fecha_fin]
                prescripcion.save()
                
                @diasAsociados.each do |t|
                  if params[t.id.to_s+"_d"].present?
                    PrescripcionDiaria.create(prescripcions_id: prescripcion.id, dia_asociados_id: t.id, cantidadGramos: params[t.id.to_s+"_cantidad"])
                  end
                end
                
                citaActual.estado=2
                citaActual.save()
                
                @mensaje="Se guardaron todos los datos exitosamente"
              else
                @mensaje="Debe diligenciar todos los campos de la respuesta"
              end
            end
          else
            redirect_to controller: "principal", action: "index"
          end
        elsif validacion.validacionParamedico()
          if citaActual.tipo=="Domiciliaria"
            @nivel=false
            if request.post?
              PreguntaCita.delete_all(["cita_medicas_id = ?", citaActual.id])
              @preguntas.each do |t|
                if params[t.id.to_s+"_p"].present?
                  if t.tipo
                    PreguntaCita.create(cita_medicas_id: citaActual.id, pregunta_id: t.id, comentario: params[t.id.to_s+"_comentario"])
                  else
                    PreguntaCita.create(cita_medicas_id: citaActual.id, pregunta_id: t.id)
                  end
                end
              end
              if params[:inr].present?
                inrPac=InrPaciente.new
                inrPac.cita_medicas_id=citaActual.id
                inrPac.anticoagulantes_id=params[:antic_inr]
                inrPac.fecha=citaActual.fecha
                inrPac.valorInr=params[:inr]
                @mensaje="Se guardaron todos los datos exitosamente"
              else
                @mensaje="Debe diligenciar todos los campos de la respuesta"
              end
            end
          else
            redirect_to controller: "principal", action: "index"
          end
        else
          redirect_to controller: "principal", action: "index"
        end
      else
        redirect_to controller: "principal", action: "index"
      end
    else
      redirect_to controller: "principal", action: "index"
    end
  end

  def modificar
  end
  
  def visualizar
    @mensaje=""
    @nivel=1
    if params[:cita].present? and CitaMedica.exists?(["id = ? ",params[:cita]])
      @nivel=3
      cita=CitaMedica.find(params[:cita])
      @fechaCita=cita.fecha
      @horaCita=cita.hora_ini
      @tipo=cita.tipo
      
      paciente=Paciente.find(cita.pacientes_id)
      @paciente=paciente.nombre+" "+paciente.apellido
      
      inrPac=InrPaciente.where(["fecha = ? and cita_medicas_id = ?", cita.fecha, cita.id]).first
      @inr=inrPac.valorInr
      
      @analisis=nil
      @plan=nil
      @subjetivo=nil
      @objetivo=nil
      @fechafin=nil
      @antic=nil
      @prescripcionDiaria=nil
      
      respuesta=RespuestaCita.find_by(cita_medicas_id: cita.id)
      if respuesta
        
        @analisis=respuesta.analisis
        @plan=respuesta.plan
        
        observacion=ObservacionMedica.find_by(respuesta_cita_id: cita.id)
        
        if observacion
          
          @subjetivo=observacion.subjetivo
          @objetivo=observacion.objetivo
          
        end
        
        prescripcion=Prescripcion.find_by(respuesta_cita_id: cita.id)
        
        if prescripcion
          @fechafin=prescripcion.fechaFin
          anticoagulante=Anticoagulante.find(prescripcion.anticoagulantes_id)
          if anticoagulante
            @antic=anticoagulante.nombre
            @prescripcionDiaria=PrescripcionDiaria.joins(:dia_asociados, :prescripcions).select("dia_asociados.nombre as dia, prescripcion_diaria.cantidadGramos as cantidad").where(["prescripcion_diaria.prescripcions_id = ?", prescripcion.id])
          end
        end
        
      end
      
    elsif params[:paciente].present?
      @nivel=2
      @citasRegistradas=CitaMedica.joins(:pacientes, :inr_pacientes).select("cita_medicas.id as id, cita_medicas.fecha as fecha, cita_medicas.hora_ini as hora, inr_pacientes.valorInr as inr, pacientes.nombre||' '||pacientes.apellido as paciente").where(["pacientes.correo = ?",params[:paciente]])
    else
      @nivel=1
      @citasRegistradas=CitaMedica.joins(:pacientes, :inr_pacientes).select("cita_medicas.id as id, cita_medicas.fecha as fecha, cita_medicas.hora_ini as hora, inr_pacientes.valorInr as inr, pacientes.nombre||' '||pacientes.apellido as paciente").all
    end
  end
  
end
