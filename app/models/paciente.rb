class Paciente < ActiveRecord::Base
  belongs_to :tipo_documentos
  belongs_to :estado_civils
  belongs_to :patologia
  
  has_many :cita_medicas, class_name: CitaMedica, foreign_key: :pacientes_id
  has_many :respuesta_cita, class_name: RespuestaCita, through: :cita_medicas
  has_many :prescripcions, class_name: Prescripcion, through: :respuesta_cita
end
