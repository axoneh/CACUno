class CreateAnticoagulantes < ActiveRecord::Migration
  def change
    create_table :anticoagulantes do |t|
      t.string :nombre, limit: 30
      t.text :descripcion
      t.integer :estado

      t.timestamps null: false
    end
    add_index(:anticoagulantes, :nombre, unique: true, name: 'index_nombre_anticoagulantes')
  end
end
