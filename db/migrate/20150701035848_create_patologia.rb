class CreatePatologia < ActiveRecord::Migration
  def change
    create_table :patologia do |t|
      t.string :nombre, limit: 30
      t.text :descripcion
      t.integer :estado

      t.timestamps null: false
    end
    add_index(:patologia, :nombre, unique: true, name: 'index_nombre_patologias')
  end
end
