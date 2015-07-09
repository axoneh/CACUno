class InrPaciente < ActiveRecord::Base
  belongs_to :cita_medicas, class_name: CitaMedica
  belongs_to :anticoagulantes, class_name: Anticoagulante
end
