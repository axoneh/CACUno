class BaseDeDatos < ActiveRecord::Migration
  def change
    
    create_table :estado_civils do |t|
      t.string :nombre, limit: 30
      t.integer :estado, null: false
      t.timestamps
    end
    
    add_index(:estado_civils, :nombre, unique: true, name: 'index_nombre_estado_civil')
    
    create_table :tipo_documentos do |t|
      t.string :nombre, limit: 30
      t.integer :estado, null: false
      t.timestamps
    end
    
    add_index(:tipo_documentos, :nombre, unique: true, name: 'index_nombre_tipo_documentos')
    
    create_table :rols do |t|
      t.string :nombre, limit: 30
      t.text :descripcion
      t.integer :estado
      t.timestamps
    end
    
    add_index(:rols, :nombre, unique: true, name: 'index_nombre_roles')
    
    create_table :dia_asociados do |t|
      t.integer :numero, null: false
      t.string :nombre, limit: 15
      t.integer :estado
      t.timestamps
    end
    
    add_index(:dia_asociados, :numero, unique: true, name: 'index_numero_dias_asociados')
    add_index(:dia_asociados, :nombre, unique: true, name: 'index_nombre_dias_asociados')
    
    create_table :anticoagulantes do |t|
      t.string :nombre, limit: 30
      t.text :descripcion
      t.integer :estado
      t.timestamps
    end
    
    add_index(:anticoagulantes, :nombre, unique: true, name: 'index_nombre_anticoagulantes')
    
    create_table :preguntas do |t|
      t.string :pregunta, limit: 50
      t.text :descripcion
      t.integer :estado
      t.timestamps
    end
    
    add_index(:preguntas, :pregunta, unique: true, name: 'index_pregunta_preguntas')
    
    create_table :patologias do |t|
      t.string :nombre, limit: 30
      t.text :descripcion
      t.integer :estado
      t.timestamps
    end
    
    add_index(:patologias, :nombre, unique: true, name: 'index_nombre_patologias')
    
    create_table :antecedente_medicos do |t|
      t.string :nombre, limit: 30
      t.text :descripcion
      t.integer :estado
      t.timestamps
    end
    
    add_index(:antecedente_medicos, :nombre, unique: true, name: 'index_nombre_antecedentes_medicos')
    
        
    create_table :cuenta_usuarios do |t|
      t.integer :identificacion
      t.references :tipo_documentos, index: true, foreign_key: true
      t.string :nombre, limit: 30
      t.string :apellido, limit: 30
      t.string :correo_electronico
      t.string :password
      t.boolean :genero, null: false
      t.string :direccion, limit: 50
      t.references :estado_civils, index: true, foreign_key: true
      t.references :rols, index: true, foreign_key: true
      t.integer :estado, null: false
    end
    
    add_index(:cuenta_usuarios, [:identificacion,:tipo_documentos_id], unique: true, name: 'index_identificacion_tipo_documento_usuario')
    add_index(:cuenta_usuarios, :correo_electronico, unique: true, name: 'index_correo_usuarios')
    
    create_table :pacientes do |t|
      t.integer :identificacion
      t.references :tipo_documentos, index: true, foreign_key: true
      t.string :nombre, limit: 30
      t.string :apellido, limit: 30
      t.string :correo_electronico
      t.boolean :genero, null: false
      t.string :direccion, limit: 50
      t.references :estado_civils, index: true, foreign_key: true
      t.references :patologias, index: true, foreign_key: true
      t.integer :estado, null: false
    end
    
    add_index(:pacientes, [:identificacion,:tipo_documentos_id], unique: true, name: 'index_identificacion_tipo_documento_paciente')
        
    create_table :antecedente_pacientes do |t|
      t.references :pacientes, index: true, foreign_key: true
      t.references :antecedente_medicos, index: true, foreign_key: true
      t.text :comentario
      t.timestamps
    end
    
    add_index(:antecedente_pacientes,[:pacientes_id,:antecedente_medicos_id], unique: true, name: 'index_pacientes_antecedentes_medicos')
    
    create_table :laboratorios do |t|
      t.references :pacientes, index: true, foreign_key: true
      t.date :fecha, null: false
      t.string :estudio, limit: 50
      t.string :resultado, limit: 20
      t.text :observacion
      t.timestamps
    end
    
    create_table :cita_medicas do |t|
      t.references :pacientes, index: true, foreign_key: true
      t.references :cuenta_usuarios, index: true, foreign_key: true
      t.date :fecha, null: false
      t.boolean :tipo, null: false
      t.integer :estado
    end
    
    add_index(:cita_medicas,[:pacientes_id, :cuenta_usuarios_id, :fecha], unique: true, name: 'index_paciente_usuario_fecha_cita')
    
    create_table :inr_pacientes do |t|
      t.references :cita_medicas, index: true, foreign_key: true
      t.references :anticoagulantes, index: true, foreign_key: true
      t.date :fecha, null: false
      t.decimal :valor_inr, null: false
      t.timestamps
    end
    
    add_index(:inr_pacientes,[:valor_inr,:fecha], unique: true, name: 'index_fecha_inr')
    
    create_table :pregunta_citas do |t|
      t.references :cita_medicas, index: true, foreign_key: true
      t.references :preguntas, index: true, foreign_key: true
      t.text :comentario
    end
    
    add_index(:pregunta_citas,[:cita_medicas_id, :preguntas_id], unique: true, name: 'index_cita_preguntas')
    
    create_table :respuesta_citas do |t|
      t.references :cita_medicas, index: true, foreign_key: true
      t.references :cuenta_usuarios, index: true, foreign_key: true
      t.text :analisis
      t.text :plan
    end
    
    add_index(:respuesta_citas,:cita_medicas_id,unique: true, name: 'index_cita_medica_respuesta')
    
    create_table :observacion_medicas do |t|
      t.references :respuesta_citas, index: true, foreign_key: true
      t.text :subjetivo
      t.text :objetivo
      t.boolean :tiempo_indefinido, null: false
      t.integer :semanas_tratamiento, null: false
    end
    
    add_index(:observacion_medicas, :respuesta_citas_id, unique: true, name: 'index_observacion_respuesta')
    
    create_table :prescripcions do |t|
      t.references :respuesta_citas, index: true, foreign_key: true
      t.references :anticoagulantes, index: true, foreign_key: true
      t.date :fecha_final, null: false
      t.timestamps
    end
    
    add_index(:prescripcions, :respuesta_citas_id, unique: true, name: 'index_prescripcion_respuesta')
    
    create_table :prescripcion_diarias do |t|
      t.references :prescripcions, index: true, foreign_key: true
      t.references :dia_asociados, index: true, foreign_key: true
      t.decimal :cantidad_gramo, null: false
    end
    
    add_index(:prescripcion_diarias, [:prescripcions_id, :dia_asociados_id], unique: true, name: 'index_prescripcion_diaria')
    
  end
end
