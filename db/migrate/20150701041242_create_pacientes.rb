class CreatePacientes < ActiveRecord::Migration
  def change
    create_table :pacientes do |t|
      t.string :identificacion
      t.references :tipo_documentos, index: true, foreign_key: true
      t.string :nombre, limit: 30
      t.string :apellido, limit: 30
      t.string :correo, limit: 45
      t.boolean :genero
      t.date :fecha_nacimiento
      t.string :direccion, limit: 50
      t.references :estado_civils, index: true, foreign_key: true
      t.references :patologia, index: true, foreign_key: true
      t.integer :estado

      t.timestamps null: false
      t.attachment :avatar
    end
    add_index(:pacientes, [:identificacion,:tipo_documentos_id], unique: true, name: 'index_identificacion_tipo_documento_paciente')
  end
end
