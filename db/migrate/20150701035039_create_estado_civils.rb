class CreateEstadoCivils < ActiveRecord::Migration
  def change
    create_table :estado_civils do |t|
      t.string :nombre, limit: 30
      t.integer :estado

      t.timestamps null: false
    end
    add_index(:estado_civils, :nombre, unique: true, name: 'index_nombre_estado_civil')
  end
end
