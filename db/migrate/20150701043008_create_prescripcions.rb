class CreatePrescripcions < ActiveRecord::Migration
  def change
    create_table :prescripcions do |t|
      t.references :respuesta_cita, index: {:unique=>true}, foreign_key: true
      t.references :anticoagulantes, index: true, foreign_key: true
      t.date :fechaFin

      t.timestamps null: false
    end
  end
end
