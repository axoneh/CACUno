class CreateInrPacientes < ActiveRecord::Migration
  def change
    create_table :inr_pacientes do |t|
      t.references :cita_medicas, index: true, foreign_key: true
      t.references :anticoagulantes, index: true, foreign_key: true
      t.date :fecha
      t.decimal :valorInr

      t.timestamps null: false
    end
  end
end
