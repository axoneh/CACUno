class Pregunta < ActiveRecord::Base
  
  has_many :pregunta_cita, class_name: PreguntaCita
  
end
