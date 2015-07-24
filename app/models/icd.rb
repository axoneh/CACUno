class Icd < ActiveRecord::Base
  has_many :cita_icds, class_name: CitaIcd, foreign_key: :icds_id
end
