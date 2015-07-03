class CreateCuentaUsuarios < ActiveRecord::Migration
  def change
    create_table :cuenta_usuarios do |t|
      t.integer :identificacion
      t.references :tipo_documentos, index: true, foreign_key: true
      t.string :nombre, limit: 30
      t.string :apellido, limit: 30
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.boolean :genero
      t.string :direccion, limit: 50
      t.references :estado_civils, index: true, foreign_key: true
      t.integer :estado
      t.references :rols , index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index(:cuenta_usuarios, [:identificacion,:tipo_documentos_id], unique: true, name: 'index_identificacion_documento_usuario')
    add_index(:cuenta_usuarios, :email, unique: true, name: 'index_correo_usuarios')
  end
end
