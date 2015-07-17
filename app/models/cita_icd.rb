class CitaIcd < ActiveRecord::Base
  belongs_to :icd
  belongs_to :cita_medicas
end
