class CreatePrescripcionDiaria < ActiveRecord::Migration
  def change
    create_table :prescripcion_diaria do |t|
      t.references :prescripcions, index: true, foreign_key: true
      t.references :dia_asociados, index: true, foreign_key: true
      t.decimal :cantidadGramos

      t.timestamps null: false
    end
    add_index(:prescripcion_diaria, [:prescripcions_id, :dia_asociados_id], unique: true, name: 'index_prescripcion_diaria')
  end
end
