class HorarioUsuario < ActiveRecord::Base
  belongs_to :cuenta_usuarios
  belongs_to :dia_asignados
  belongs_to :sucursals
end
