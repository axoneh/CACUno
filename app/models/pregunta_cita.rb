class PreguntaCita < ActiveRecord::Base
  belongs_to :dita_medicas
  belongs_to :pregunta
end
