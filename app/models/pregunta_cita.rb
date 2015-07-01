class PreguntaCita < ActiveRecord::Base
  belongs_to :cita_medicas
  belongs_to :pregunta
end
