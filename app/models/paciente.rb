class Paciente < ActiveRecord::Base
  belongs_to :tipo_documentos, class_name: TipoDocumento
  belongs_to :estado_civils, class_name: EstadoCivil
  belongs_to :patologia, class_name: Patologia
  belongs_to :ciudad, class_name: Ciudad
  
  has_many :cita_medicas, class_name: CitaMedica, foreign_key: :pacientes_id
  has_many :laboratorios,class_name: Laboratorio, foreign_key: :pacientes_id
  has_many :antecedente_paciente, class_name: AntecedentePaciente, foreign_key: :pacientes_id
  has_many :prescripcions,class_name: Prescripcion , through: :cita_medicas
  has_many :inr_paciente, class_name: InrPaciente, through: :cita_medicas
  
  has_attached_file :avatar, :styles => { :medium => "#300x300>" }, :default_url => "/images/:style/missing.png"
  
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  validates_attachment_presence :avatar
  
  def ultimaCita
    cita_medicas.where(["generico = ? and estado = ? and tipo = ?", false, 2, "Presencial"]).last
  end
  
  def ultimaVisita
    cita_medicas.where(["generico = ? and estado > ? and tipo = ?", false, 1, "Domiciliaria"]).last
  end
  
end
