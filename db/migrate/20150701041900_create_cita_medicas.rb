class CreateCitaMedicas < ActiveRecord::Migration
  def change
    create_table :cita_medicas do |t|
      t.references :pacientes, index: true, foreign_key: true
      t.references :cuenta_usuarios, index: true, foreign_key: true
      t.date :fecha
      t.string :tipo
      t.integer :estado
      t.time :hora_ini

      t.timestamps null: false
    end
    add_index(:cita_medicas, [:pacientes_id, :fecha, :hora_ini], unique: true, name: 'index_paciente_fecha_hora_cita')
    add_index(:cita_medicas, [:cuenta_usuarios_id, :fecha, :hora_ini], unique: true, name: 'index_usuario_fecha_hora_cita')
  end
end
