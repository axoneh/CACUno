class DiaAsociado < ActiveRecord::Base
  has_many :prescripcion_diaria, class_name: PrescripcionDiaria
end
