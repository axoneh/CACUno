class CitaMedica < ActiveRecord::Base
  belongs_to :pacientes, class_name: Paciente
  belongs_to :cuenta_usuarios, class_name: CuentaUsuario
  
  has_many :inr_pacientes, class_name: InrPaciente
  has_many :pregunta_cita, class_name: PreguntaCita
  has_many :respuesta_cita, class_name: RespuestaCita, foreign_key: :cita_medicas_id
end
