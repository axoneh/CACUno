class CreateRespuestaCita < ActiveRecord::Migration
  def change
    create_table :respuesta_cita do |t|
      t.references :cita_medicas, index: {:unique=>true}, foreign_key: true
      t.references :cuenta_usuarios, index: true, foreign_key: true
      t.text :analisis
      t.text :plan
      t.integer :estado
      
      t.timestamps null: false
    end
  end
end
