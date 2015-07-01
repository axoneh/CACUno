class PrescripcionDiaria < ActiveRecord::Base
  belongs_to :prescripcions
  belongs_to :dia_asociados
end
