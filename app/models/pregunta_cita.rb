class PreguntaCita < ActiveRecord::Base
  belongs_to :cita_medicas, class_name: CitaMedica
  belongs_to :pregunta, class_name: Pregunta
end
