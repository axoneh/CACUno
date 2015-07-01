class CreateObservacionMedicas < ActiveRecord::Migration
  def change
    create_table :observacion_medicas do |t|
      t.references :respuesta_cita, index: {:unique=>true}, foreign_key: true
      t.text :subjetivo
      t.text :objetivo
      t.boolean :tiempoIndefinido
      t.integer :semanasTratamiento

      t.timestamps null: false
    end
  end
end
