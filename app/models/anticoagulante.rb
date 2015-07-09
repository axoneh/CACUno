class Anticoagulante < ActiveRecord::Base
  has_many :inr_pacientes, class_name: InrPaciente
  has_many :prescripcions, class_name: Prescripcion
end
