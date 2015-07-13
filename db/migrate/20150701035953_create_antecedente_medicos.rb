class CreateAntecedenteMedicos < ActiveRecord::Migration
  def change
    create_table :antecedente_medicos do |t|
      t.string :nombre
      t.string :descripcion
      t.boolean :tipo
      t.integer :estado
      t.string :tag

      t.timestamps null: false
    end
    add_index(:antecedente_medicos, :nombre, unique: true, name: 'index_nombre_antecedentes_medicos')
    add_index(:antecedente_medicos, [:tag, :estado], unique: true, name: 'index_estado_tags_medicos')
  end
end
