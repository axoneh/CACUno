class AntecedentePaciente < ActiveRecord::Base
  belongs_to :pacientes, class_name: Paciente
  belongs_to :antecedente_medicos, class_name: AntecedenteMedico
end
