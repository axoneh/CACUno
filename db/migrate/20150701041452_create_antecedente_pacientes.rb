class CreateAntecedentePacientes < ActiveRecord::Migration
  def change
    create_table :antecedente_pacientes do |t|
      t.references :pacientes, index: true, foreign_key: true
      t.references :antecedente_medicos, index: true, foreign_key: true
      t.text :comentario

      t.timestamps null: false
    end
    add_index(:antecedente_pacientes,[:pacientes_id,:antecedente_medicos_id], unique: true, name: 'index_pacientes_antecedentes_medicos')
  end
end
