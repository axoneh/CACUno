class RespuestaCita < ActiveRecord::Base
  belongs_to :cita_medicas, class_name: CitaMedica
  belongs_to :cuenta_usuarios, class_name: CuentaUsuario
  
  has_one :observacion_medicas, class_name: ObservacionMedica
  has_one :prescripcions, class_name: Prescripcion
  
end
