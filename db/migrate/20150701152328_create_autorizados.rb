class CreateAutorizados < ActiveRecord::Migration
  def change
    create_table :autorizados do |t|
      t.references :rols, index: true, foreign_key: true
      t.string :correo, limit: 45
      t.string :password, limit: 30
      t.boolean :estado

      t.timestamps null: false
    end
    add_index :autorizados, :correo, unique: true, name: 'index_correo_autorizado'
    
    change_table :cuenta_usuarios do |t|
      t.references :autorizados, index: {:unique=>true}, foreign_key: true
    end
  end
end
