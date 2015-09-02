class CuentaUsuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :omniauth_providers => [:google_oauth2]
  
  belongs_to :rols, class_name: Rol
  belongs_to :estado_civils, class_name: EstadoCivil
  belongs_to :tipo_documentos, class_name: TipoDocumento
  belongs_to :ciudad, class_name: Ciudad
  
  def self.from_omniauth(auth)
    where(["email = ? and estado < ? ", auth.info.email ,3]).first
  end
  
end
