class AntecedentePaciente < ActiveRecord::Base
  belongs_to :pacientes
  belongs_to :antecedente_medicos
end
