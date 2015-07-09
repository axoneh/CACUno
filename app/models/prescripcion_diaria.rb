class PrescripcionDiaria < ActiveRecord::Base
  belongs_to :prescripcions, class_name: Prescripcion
  belongs_to :dia_asociados, class_name: DiaAsociado
end
