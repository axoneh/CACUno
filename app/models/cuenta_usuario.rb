class CuentaUsuario < ActiveRecord::Base
  belongs_to :tipo_documentos
  belongs_to :rols
  belongs_to :estado_civils
end
