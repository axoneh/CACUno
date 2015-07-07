class CreateCitaMedicas < ActiveRecord::Migration
  def change
    create_table :cita_medicas do |t|
      t.references :pacientes, index: true, foreign_key: true
      t.references :cuenta_usuarios, index: true, foreign_key: true
      t.date :fecha
      t.string :tipo
      t.integer :estado
      t.time :hora_ini
      t.time :hora_fin

      t.timestamps null: false
    end    
  end
end
