class CreateHorarioUsuarios < ActiveRecord::Migration
  def change
    create_table :horario_usuarios do |t|
      t.references :cuenta_usuarios, index: true, foreign_key: true
      t.references :dia_asignados, index: true, foreign_key: true
      t.references :sucursals, index: true, foreign_key: true
      t.time :hora_inicial
      t.time :hora_final

      t.timestamps null: false
    end
    add_index(:horario_usuarios,[:cuenta_usuarios_id, :dia_asignados_id], unique: true, name: 'index_horario_usuario_dia')
  end
end
