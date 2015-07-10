class RespuestaCita < ActiveRecord::Base
  belongs_to :cita_medicas, class_name: CitaMedica
  belongs_to :cuenta_usuarios, class_name: CuentaUsuario
  
  has_many :observacion_medicas, class_name: ObservacionMedica
  has_many :prescripcions, class_name: Prescripcion
  
end
