class CitaMedica < ActiveRecord::Base
  belongs_to :pacientes
  belongs_to :cuenta_usuarios
end
