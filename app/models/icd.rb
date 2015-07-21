class Icd < ActiveRecord::Base
  has_many :cita_icds, clas_name: CitaIcd
end
