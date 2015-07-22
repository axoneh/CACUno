class Ayuda < ActiveRecord::Migration
  def change
    change_table :pacientes do |t|
      t.text :antecedente_general
    end
    
    change_table :prescripcions do |t|
      t.text :recomendacion
    end
    
    change_table :observacion_medicas do |t|
      t.integer :frecuencia_cardiaca
      t.integer :hiper_sistolica
      t.integer :hiper_diastolica
    end
    
  end
end
