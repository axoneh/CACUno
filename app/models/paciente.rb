class Paciente < ActiveRecord::Base
  belongs_to :tipo_documentos
  belongs_to :estado_civils
  belongs_to :patologia
  
  has_many :cita_medicas, class_name: CitaMedica
  has_many :laboratorios,class_name: Laboratorio
end
