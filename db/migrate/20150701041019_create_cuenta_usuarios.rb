class CreateCuentaUsuarios < ActiveRecord::Migration
  def change
    create_table :cuenta_usuarios do |t|
      t.integer :identificacion
      t.references :tipo_documentos, index: true, foreign_key: true
      t.string :nombre, limit: 30
      t.string :apellido, limit: 30
      t.string :correo, limit: 45
      t.string :password, limit: 30
      t.boolean :genero
      t.string :direccion, limit: 50
      t.references :estado_civils, index: true, foreign_key: true
      t.boolean :estado

      t.timestamps null: false
    end
    add_index(:cuenta_usuarios, [:identificacion,:tipo_documentos_id], unique: true, name: 'index_identificacion_documento_usuario')
    add_index(:cuenta_usuarios, :correo, unique: true, name: 'index_correo_usuarios')
  end
end
