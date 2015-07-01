class CreatePreguntaCita < ActiveRecord::Migration
  def change
    create_table :pregunta_cita do |t|
      t.references :cita_medicas, index: true, foreign_key: true
      t.references :pregunta, index: true, foreign_key: true
      t.text :comentario

      t.timestamps null: false
    end
    add_index(:pregunta_cita,[:cita_medicas_id, :pregunta_id], unique: true, name: 'index_cita_preguntas')
    
  end
end
