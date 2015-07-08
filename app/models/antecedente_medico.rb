class AntecedenteMedico < ActiveRecord::Base
  has_many :antecedente_pacientes, class_name: AntecedentePaciente
end
