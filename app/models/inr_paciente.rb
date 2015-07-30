class InrPaciente < ActiveRecord::Base
  belongs_to :cita_medicas, class_name: CitaMedica
  belongs_to :anticoagulantes, class_name: Anticoagulante
  has_many :respuesta_cita, class_name: RespuestaCita, through: :cita_medicas
end
