Rails.application.routes.draw do

  get 'usuario/visualizar'

  get 'usuario/actualizar'

  get 'usuario/agregar'

  get 'usuario/visualizar'

  get 'usuario/actualizar'

  get 'usuario/agregar'

  get 'medico_internista/menu'

  get 'autorizado/agregar'
  post 'autorizado/agregar'

  get 'autorizado/actualizar'

  get 'autorizado/desactivar'

  get 'administracion/menu'

  get 'usuario/actualizar'
  post 'usuario/actualizar'

  get 'sesion/iniciar'
  post 'sesion/iniciar'

  get 'sesion/cerrar'

  get 'principal/index'
  
  root :to => 'principal#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  # :confirmable => enviar correo de verificacion de usuario
  # :recoverable => restablece la contraseña y envia correo con instrucciones
  # :database_authenticatable => cifra y almacena una contraseña en la base de datos para validar la autenticidad de un usuario mientras que la firma. La autenticación se puede realizar tanto a través de las peticiones POST o autenticación básica HTTP.
  # :registerable => maneja la firma usuarios a través de un proceso de registro, también lo que les permite editar y destruir su cuenta.
  # :rememberable => gestiona la generación y la limpieza de una ficha para recordar al usuario de una cookie guardada.
  # :trackable => pistas ingresar recuento, marcas de tiempo y dirección IP.
  # :timeoutable => expira sesiones que no han estado activos en un período de tiempo especificado.
  # :validatable => proporciona validaciones de correo electrónico y contraseña. Es opcional y puede ser personalizado, por lo que usted es capaz de definir sus propias validaciones.
  # :lockable => bloquea una cuenta después de un número determinado de intentos de inicio de sesión fallidos. Se puede desbloquear a través de correo electrónico o después de un período de tiempo especificado.
  
  #
  # t.string :email,              null: false, default: ""
  # t.string :encrypted_password, null: false, default: ""
  #
end
