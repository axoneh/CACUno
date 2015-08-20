class ObservacionMedica < ActiveRecord::Base
  belongs_to :cita_medicas, class_name: CitaMedica
end
