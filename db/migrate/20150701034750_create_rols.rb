class CreateRols < ActiveRecord::Migration
  def change
    create_table :rols do |t|
      t.string :nombre, limit: 20
      t.text :descripcion

      t.timestamps null: false
    end
    add_index(:rols, :nombre, unique: true, name: 'index_nombre_roles')
  end
end
