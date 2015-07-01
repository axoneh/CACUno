class CreateCitaMedicas < ActiveRecord::Migration
  def change
    create_table :cita_medicas do |t|
      t.references :pacientes, index: true, foreign_key: true
      t.references :cuenta_usuarios, index: true, foreign_key: true
      t.date :fecha
      t.boolean :tipo
      t.integer :estado

      t.timestamps null: false
    end
    add_index(:cita_medicas,[:pacientes_id, :cuenta_usuarios_id, :fecha], unique: true, name: 'index_paciente_usuario_fecha_cita')
  end
end
