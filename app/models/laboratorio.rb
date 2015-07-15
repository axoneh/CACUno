class Laboratorio < ActiveRecord::Base
  belongs_to :pacientes, class_name: Paciente
end
