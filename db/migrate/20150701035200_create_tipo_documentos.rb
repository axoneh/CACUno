class CreateTipoDocumentos < ActiveRecord::Migration
  def change
    create_table :tipo_documentos do |t|
      t.string :nombre, limit: 30
      t.integer :estado

      t.timestamps null: false
    end
    add_index(:tipo_documentos, :nombre, unique: true, name: 'index_nombre_tipo_documentos')
  end
end
