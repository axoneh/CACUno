class CreateLaboratorios < ActiveRecord::Migration
  def change
    create_table :laboratorios do |t|
      t.references :pacientes, index: true, foreign_key: true
      t.date :fecha
      t.string :estudio, limit: 50
      t.string :resultado, limit: 20
      t.text :observacion

      t.timestamps null: false
    end
  end
end
