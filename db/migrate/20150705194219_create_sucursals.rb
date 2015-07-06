class CreateSucursals < ActiveRecord::Migration
  def change
    create_table :sucursals do |t|
      t.string :nombre, limit: 45
      t.string :direccion, limit: 50
      t.integer :estado

      t.timestamps null: false
    end
    add_index :sucursals, :nombre, unique: true
  end
end
