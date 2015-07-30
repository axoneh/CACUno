class Anticoagulante < ActiveRecord::Base
  has_many :prescripcions, class_name: Prescripcion
end
