class CuentaUsuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable
  
  belongs_to :rols
  belongs_to :estado_civils
  belongs_to :tipo_documentos
  
end
