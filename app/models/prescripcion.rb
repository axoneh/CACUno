class Prescripcion < ActiveRecord::Base
  belongs_to :respuesta_cita, class_name: RespuestaCita
  belongs_to :anticoagulantes, class_name: Anticoagulante
  
  has_many :prescripcion_diaria, class_name: PrescripcionDiaria, foreign_key: :prescripcions_id
  
end
