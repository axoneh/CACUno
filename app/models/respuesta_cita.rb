class RespuestaCita < ActiveRecord::Base
  belongs_to :cita_medicas
  belongs_to :cuenta_usuarios
end
