class InrPaciente < ActiveRecord::Base
  belongs_to :cita_medicas
  belongs_to :anticoagulantes
end
