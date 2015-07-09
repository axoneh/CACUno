class Prescripcion < ActiveRecord::Base
  belongs_to :respuesta_cita, class_name: RespuestaCita
  belongs_to :anticoagulantes, class_name: Anticoagulante
end
