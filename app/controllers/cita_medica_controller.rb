class CitaMedicaController < ApplicationController
  def crear
  end

  def aplicar
    @mensaje=""
    validacion=Application.new
    if validacion.validacionMedico()
      correop=params[:paciente]
      if correop
        paciente=Paciente.find_by(correo: correop)
        citaActual=CitaMedica.new
        citaActual.pacientes_id=paciente.id
        citaActual.cuenta_usuarios_id=current_cuenta_usuario.id
        citaActual.fecha=Date.now.to_date
        citaActual.estado = 1
        citaActual.hora_ini=Time.now.to_time
        citaActual.tipo=true
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

  end

  def modificar
  end
  
  def visualizar
    @mensaje=""
    @nivel=1
    if params[:cita].present?
      @nivel=3
      cita=CitaMedica.find(params[:cita])
      @fechaCita=cita.fecha
      @horaCita=cita.hora_ini
      
      paciente=Paciente.find(cita.pacientes_id)
      @paciente=paciente.nombre+" "+paciente.apellido
      
      inrpaciente=InrPaciente.where(["fecha = ? and cita_medicas_id = ?", cita.fecha, cita.id])
      @inr=inrpaciente.valorInr
      
    elsif params[:paciente].present?
      @nivel=2
      @citasRegistradas=CitaMedica.joins(:pacientes, :inr_pacientes).select("cita_medicas.id as id, cita_medicas.fecha as fecha, cita_medicas.hora_ini as hora, inr_pacientes.valorInr as inr, pacientes.nombre||' '||pacientes.apellido as paciente").where(["pacientes.correo = ?",params[:paciente]])
    else
      @nivel=1
      @citasRegistradas=CitaMedica.joins(:pacientes, :inr_pacientes).select("cita_medicas.id as id, cita_medicas.fecha as fecha, cita_medicas.hora_ini as hora, inr_pacientes.valorInr as inr, pacientes.nombre||' '||pacientes.apellido as paciente").all
    end
  end
  
end
