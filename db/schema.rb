# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150710231125) do

  create_table "antecedente_medicos", force: :cascade do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.boolean  "tipo"
    t.integer  "estado"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "antecedente_medicos", ["nombre"], name: "index_nombre_antecedentes_medicos", unique: true

  create_table "antecedente_pacientes", force: :cascade do |t|
    t.integer  "pacientes_id"
    t.integer  "antecedente_medicos_id"
    t.text     "comentario"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "antecedente_pacientes", ["antecedente_medicos_id"], name: "index_antecedente_pacientes_on_antecedente_medicos_id"
  add_index "antecedente_pacientes", ["pacientes_id", "antecedente_medicos_id"], name: "index_pacientes_antecedentes_medicos", unique: true
  add_index "antecedente_pacientes", ["pacientes_id"], name: "index_antecedente_pacientes_on_pacientes_id"

  create_table "anticoagulantes", force: :cascade do |t|
    t.string   "nombre",      limit: 30
    t.string   "descripcion"
    t.integer  "estado"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "anticoagulantes", ["nombre"], name: "index_nombre_anticoagulantes", unique: true

  create_table "cita_medicas", force: :cascade do |t|
    t.integer  "pacientes_id"
    t.integer  "cuenta_usuarios_id"
    t.date     "fecha"
    t.string   "tipo"
    t.integer  "estado"
    t.time     "hora_ini"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "cita_medicas", ["cuenta_usuarios_id", "fecha", "hora_ini"], name: "index_usuario_fecha_hora_cita", unique: true
  add_index "cita_medicas", ["cuenta_usuarios_id"], name: "index_cita_medicas_on_cuenta_usuarios_id"
  add_index "cita_medicas", ["pacientes_id", "fecha", "hora_ini"], name: "index_paciente_fecha_hora_cita", unique: true
  add_index "cita_medicas", ["pacientes_id"], name: "index_cita_medicas_on_pacientes_id"

  create_table "cuenta_usuarios", force: :cascade do |t|
    t.string   "identificacion"
    t.integer  "tipo_documentos_id"
    t.string   "nombre",                 limit: 30
    t.string   "apellido",               limit: 30
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.boolean  "genero"
    t.string   "direccion",              limit: 50
    t.string   "especialidad"
    t.date     "fecha_nacimiento"
    t.integer  "estado"
    t.integer  "rols_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "provider"
    t.string   "uid"
    t.boolean  "encargado_respuesta",               default: false
  end

  add_index "cuenta_usuarios", ["email"], name: "index_correo_usuarios", unique: true
  add_index "cuenta_usuarios", ["identificacion", "tipo_documentos_id"], name: "index_identificacion_documento_usuario", unique: true
  add_index "cuenta_usuarios", ["rols_id"], name: "index_cuenta_usuarios_on_rols_id"
  add_index "cuenta_usuarios", ["tipo_documentos_id"], name: "index_cuenta_usuarios_on_tipo_documentos_id"

  create_table "dia_asociados", force: :cascade do |t|
    t.integer  "numero"
    t.string   "nombre",     limit: 15
    t.integer  "estado"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "dia_asociados", ["nombre"], name: "index_nombre_dias_asociados", unique: true
  add_index "dia_asociados", ["numero"], name: "index_numero_dias_asociados", unique: true

  create_table "estado_civils", force: :cascade do |t|
    t.string   "nombre",     limit: 30
    t.integer  "estado"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "estado_civils", ["nombre"], name: "index_nombre_estado_civil", unique: true

  create_table "horario_usuarios", force: :cascade do |t|
    t.integer  "cuenta_usuarios_id"
    t.integer  "dia_asignados_id"
    t.integer  "sucursals_id"
    t.time     "hora_inicial"
    t.time     "hora_final"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "horario_usuarios", ["cuenta_usuarios_id", "dia_asignados_id"], name: "index_horario_usuario_dia", unique: true
  add_index "horario_usuarios", ["cuenta_usuarios_id"], name: "index_horario_usuarios_on_cuenta_usuarios_id"
  add_index "horario_usuarios", ["dia_asignados_id"], name: "index_horario_usuarios_on_dia_asignados_id"
  add_index "horario_usuarios", ["sucursals_id"], name: "index_horario_usuarios_on_sucursals_id"

  create_table "inr_pacientes", force: :cascade do |t|
    t.integer  "cita_medicas_id"
    t.integer  "anticoagulantes_id"
    t.date     "fecha"
    t.decimal  "valorInr"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "inr_pacientes", ["anticoagulantes_id"], name: "index_inr_pacientes_on_anticoagulantes_id"
  add_index "inr_pacientes", ["cita_medicas_id"], name: "index_inr_pacientes_on_cita_medicas_id"

  create_table "laboratorios", force: :cascade do |t|
    t.integer  "pacientes_id"
    t.date     "fecha"
    t.string   "estudio",      limit: 50
    t.string   "resultado",    limit: 20
    t.text     "observacion"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "laboratorios", ["pacientes_id"], name: "index_laboratorios_on_pacientes_id"

  create_table "observacion_medicas", force: :cascade do |t|
    t.integer  "respuesta_cita_id"
    t.text     "subjetivo"
    t.text     "objetivo"
    t.boolean  "tiempoIndefinido"
    t.integer  "semanasTratamiento"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "observacion_medicas", ["respuesta_cita_id"], name: "index_observacion_medicas_on_respuesta_cita_id", unique: true

  create_table "pacientes", force: :cascade do |t|
    t.string   "identificacion"
    t.integer  "tipo_documentos_id"
    t.string   "nombre",             limit: 30
    t.string   "apellido",           limit: 30
    t.string   "correo",             limit: 45
    t.boolean  "genero"
    t.date     "fecha_nacimiento"
    t.string   "direccion",          limit: 50
    t.integer  "estado_civils_id"
    t.integer  "patologia_id"
    t.integer  "estado"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "pacientes", ["estado_civils_id"], name: "index_pacientes_on_estado_civils_id"
  add_index "pacientes", ["identificacion", "tipo_documentos_id"], name: "index_identificacion_tipo_documento_paciente", unique: true
  add_index "pacientes", ["patologia_id"], name: "index_pacientes_on_patologia_id"
  add_index "pacientes", ["tipo_documentos_id"], name: "index_pacientes_on_tipo_documentos_id"

  create_table "patologia", force: :cascade do |t|
    t.string   "nombre",      limit: 30
    t.text     "descripcion"
    t.integer  "estado"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "patologia", ["nombre"], name: "index_nombre_patologias", unique: true

  create_table "pregunta", force: :cascade do |t|
    t.string   "pregunta",    limit: 50
    t.string   "descripcion"
    t.integer  "estado"
    t.boolean  "tipo"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "pregunta", ["pregunta"], name: "index_pregunta_preguntas", unique: true

  create_table "pregunta_cita", force: :cascade do |t|
    t.integer  "cita_medicas_id"
    t.integer  "pregunta_id"
    t.text     "comentario"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pregunta_cita", ["cita_medicas_id", "pregunta_id"], name: "index_cita_preguntas", unique: true
  add_index "pregunta_cita", ["cita_medicas_id"], name: "index_pregunta_cita_on_cita_medicas_id"
  add_index "pregunta_cita", ["pregunta_id"], name: "index_pregunta_cita_on_pregunta_id"

  create_table "prescripcion_diaria", force: :cascade do |t|
    t.integer  "prescripcions_id"
    t.integer  "dia_asociados_id"
    t.decimal  "cantidadGramos"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "prescripcion_diaria", ["dia_asociados_id"], name: "index_prescripcion_diaria_on_dia_asociados_id"
  add_index "prescripcion_diaria", ["prescripcions_id", "dia_asociados_id"], name: "index_prescripcion_diaria", unique: true
  add_index "prescripcion_diaria", ["prescripcions_id"], name: "index_prescripcion_diaria_on_prescripcions_id"

  create_table "prescripcions", force: :cascade do |t|
    t.integer  "respuesta_cita_id"
    t.integer  "anticoagulantes_id"
    t.date     "fechaFin"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "prescripcions", ["anticoagulantes_id"], name: "index_prescripcions_on_anticoagulantes_id"
  add_index "prescripcions", ["respuesta_cita_id"], name: "index_prescripcions_on_respuesta_cita_id", unique: true

  create_table "respuesta_cita", force: :cascade do |t|
    t.integer  "cita_medicas_id"
    t.integer  "cuenta_usuarios_id"
    t.text     "analisis"
    t.text     "plan"
    t.integer  "estado"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "respuesta_cita", ["cita_medicas_id"], name: "index_respuesta_cita_on_cita_medicas_id", unique: true
  add_index "respuesta_cita", ["cuenta_usuarios_id"], name: "index_respuesta_cita_on_cuenta_usuarios_id"

  create_table "rols", force: :cascade do |t|
    t.string   "nombre",      limit: 20
    t.text     "descripcion"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "rols", ["nombre"], name: "index_nombre_roles", unique: true

  create_table "sucursals", force: :cascade do |t|
    t.string   "nombre",     limit: 45
    t.string   "direccion",  limit: 50
    t.integer  "estado"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "sucursals", ["nombre"], name: "index_sucursals_on_nombre", unique: true

  create_table "tipo_documentos", force: :cascade do |t|
    t.string   "nombre",     limit: 30
    t.integer  "estado"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "tipo_documentos", ["nombre"], name: "index_nombre_tipo_documentos", unique: true

end
