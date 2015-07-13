class CreatePregunta < ActiveRecord::Migration
  def change
    create_table :pregunta do |t|
      t.string :pregunta, limit: 50
      t.string :descripcion
      t.integer :estado
      t.boolean :tipo
      t.string :tag

      t.timestamps null: false
    end
    add_index(:pregunta, :pregunta, unique: true, name: 'index_pregunta_preguntas')
    add_index(:pregunta, [:tag, :estado], unique: true, name: 'index_tag_estado_pregunta')
  end
end
