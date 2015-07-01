class CreateDiaAsociados < ActiveRecord::Migration
  def change
    create_table :dia_asociados do |t|
      t.integer :numero
      t.string :nombre, limit: 15
      t.integer :estado

      t.timestamps null: false
    end
    add_index(:dia_asociados, :numero, unique: true, name: 'index_numero_dias_asociados')
    add_index(:dia_asociados, :nombre, unique: true, name: 'index_nombre_dias_asociados')
  end
end
