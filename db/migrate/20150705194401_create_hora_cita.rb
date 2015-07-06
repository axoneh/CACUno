class CreateHoraCita < ActiveRecord::Migration
  def change
    create_table :hora_cita do |t|
      t.time :hora_inicial
      t.time :hora_final

      t.timestamps null: false
    end
    
    add_index(:hora_cita, [:hora_inicial , :hora_inicial], unique: true, name: 'index_hora_inicial_final')
    
    change_table :cita_medicas do |t|
      t.references :hora_cita, index: true, foreign_key: true
      t.references :sucursals, index: true, foreign_key: true
    end
    
    add_index(:cita_medicas, [:hora_cita_id, :pacientes_id, :fecha], unique: true, name: 'index_')
    
  end
end
