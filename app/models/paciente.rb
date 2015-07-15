class Paciente < ActiveRecord::Base
  belongs_to :tipo_documentos, class_name: TipoDocumento
  belongs_to :estado_civils, class_name: EstadoCivil
  belongs_to :patologia, class_name: Patologia
  
  has_many :cita_medicas, class_name: CitaMedica, foreign_key: :pacientes_id
  has_many :laboratorios,class_name: Laboratorio
  has_many :antecedente_paciente, class_name: AntecedentePaciente, foreign_key: :pacientes_id
end
