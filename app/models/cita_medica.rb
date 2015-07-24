class CitaMedica < ActiveRecord::Base
  belongs_to :pacientes, class_name: Paciente
  belongs_to :cuenta_usuarios, class_name: CuentaUsuario
  
  has_many :inr_pacientes, class_name: InrPaciente, foreign_key: :cita_medicas_id
  has_many :pregunta_cita, class_name: PreguntaCita, foreign_key: :cita_medicas_id
  has_many :respuesta_cita, class_name: RespuestaCita, foreign_key: :cita_medicas_id
  has_many :cita_icds, class_name: CitaIcd, foreign_key: :cita_medicas_id
end
