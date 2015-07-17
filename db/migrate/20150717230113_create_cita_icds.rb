class CreateCitaIcds < ActiveRecord::Migration
  def change
    create_table :cita_icds do |t|
      t.references :icds, index: true, foreign_key: true
      t.references :cita_medicas, index: true, foreign_key: true

      t.timestamps null: false
    end
    
    add_index(:cita_icds,[:icds_id, :cita_medicas_id], unique: true, name: 'index_icd_cita_medica')
    
  end
end
