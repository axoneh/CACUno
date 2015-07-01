class Paciente < ActiveRecord::Base
  belongs_to :tipo_documentos
  belongs_to :estado_civils
  belongs_to :patologia
end
