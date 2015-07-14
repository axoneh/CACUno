class Pregunta < ActiveRecord::Base
  
  has_many :pregunta_cita, class_name: PreguntaCita, foreign_key: :pregunta_id
  
end
