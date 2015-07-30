class ObservacionMedica < ActiveRecord::Base
  belongs_to :respuesta_cita, class_name: RespuestaCita
end
