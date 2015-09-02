class Ciudad < ActiveRecord::Base
  has_many :pacientes, class_name: Paciente, foreign_key: :ciudads_id
  has_many :cuenta_usuarios, class_name: CuentaUsuario, foreign_key: :ciudads_id
end
