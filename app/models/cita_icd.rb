class CitaIcd < ActiveRecord::Base
  belongs_to :icds, class_name: Icd
  belongs_to :cita_medicas, class_name: CitaMedica
end
