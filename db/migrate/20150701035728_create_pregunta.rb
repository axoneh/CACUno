class CreatePregunta < ActiveRecord::Migration
  def change
    create_table :pregunta do |t|
      t.string :pregunta, limit: 50
      t.text :descripcion
      t.integer :estado
      t.boolean :tipo

      t.timestamps null: false
    end
    add_index(:pregunta, :pregunta, unique: true, name: 'index_pregunta_preguntas')
  end
end
