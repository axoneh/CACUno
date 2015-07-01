class Prescripcion < ActiveRecord::Base
  belongs_to :respuesta_cita
  belongs_to :anticoagulantes
end
