class CuentaUsuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :omniauthable, :omniauth_providers => [:google_oauth2]
  
  belongs_to :rols, class_name: Rol
  belongs_to :estado_civils, class_name: EstadoCivil
  belongs_to :tipo_documentos, class_name: TipoDocumento
  
  def self.from_omniauth(auth)
    where(["email = ? and estado< ? ", auth.info.email ,3]).first do |user|
      user.provider = provider
      user.uid = uid
      user.link_foto=auth.info.image
      user.nombre=auth.info.first_name
      user.apellido=auth.info.last_name
    end
  end
  
end
