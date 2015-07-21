class CreateCuentaUsuarios < ActiveRecord::Migration
  def change
    create_table :cuenta_usuarios do |t|
      t.string :identificacion
      t.integer :tipo_documentos_id, index: true
      t.string :nombre, limit: 30
      t.string :apellido, limit: 30
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.boolean :genero
      t.string :direccion, limit: 50
      t.string :especialidad
      t.date :fecha_nacimiento
      t.integer :estado
      t.integer :rols_id, index: true
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :encargado_respuesta, default: false
      t.timestamps null: false
      t.string :link_foto
    end
    add_foreign_key(:cuenta_usuarios, :tipo_documentos, column: :tipo_documentos)
    add_foreign_key(:cuenta_usuarios, :rols, column: :rols)
    add_index(:cuenta_usuarios, [:identificacion ,:tipo_documentos_id], unique: true, name: 'index_identificacion_documento_usuario')
    add_index(:cuenta_usuarios, :email, unique: true, name: 'index_correo_usuarios')
  end
end
