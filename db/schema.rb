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

ActiveRecord::Schema.define(version: 20150629182552) do

  create_table "antecedente_medicos", force: :cascade do |t|
    t.string   "nombre",      limit: 30
    t.text     "descripcion"
    t.integer  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "antecedente_medicos", ["nombre"], name: "index_nombre_antecedentes_medicos", unique: true

  create_table "antecedente_pacientes", force: :cascade do |t|
    t.integer  "pacientes_id"
    t.integer  "antecedente_medicos_id"
    t.text     "comentario"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "antecedente_pacientes", ["antecedente_medicos_id"], name: "index_antecedente_pacientes_on_antecedente_medicos_id"
  add_index "antecedente_pacientes", ["pacientes_id", "antecedente_medicos_id"], name: "index_pacientes_antecedentes_medicos", unique: true
  add_index "antecedente_pacientes", ["pacientes_id"], name: "index_antecedente_pacientes_on_pacientes_id"

  create_table "anticoagulantes", force: :cascade do |t|
    t.string   "nombre",      limit: 30
    t.text     "descripcion"
    t.integer  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "anticoagulantes", ["nombre"], name: "index_nombre_anticoagulantes", unique: true

  create_table "cita_medicas", force: :cascade do |t|
    t.integer "pacientes_id"
    t.integer "cuenta_usuarios_id"
    t.date    "fecha",              null: false
    t.boolean "tipo",               null: false
    t.integer "estado"
  end

  add_index "cita_medicas", ["cuenta_usuarios_id"], name: "index_cita_medicas_on_cuenta_usuarios_id"
  add_index "cita_medicas", ["pacientes_id", "cuenta_usuarios_id", "fecha"], name: "index_paciente_usuario_fecha_cita", unique: true
  add_index "cita_medicas", ["pacientes_id"], name: "index_cita_medicas_on_pacientes_id"

  create_table "cuenta_usuarios", force: :cascade do |t|
    t.integer "identificacion"
    t.integer "tipo_documentos_id"
    t.string  "nombre",             limit: 30
    t.string  "apellido",           limit: 30
    t.string  "correo_electronico"
    t.string  "password"
    t.boolean "genero",                        null: false
    t.string  "direccion",          limit: 50
    t.integer "estado_civils_id"
    t.integer "rols_id"
    t.integer "estado",                        null: false
  end

  add_index "cuenta_usuarios", ["correo_electronico"], name: "index_correo_usuarios", unique: true
  add_index "cuenta_usuarios", ["estado_civils_id"], name: "index_cuenta_usuarios_on_estado_civils_id"
  add_index "cuenta_usuarios", ["identificacion", "tipo_documentos_id"], name: "index_identificacion_tipo_documento_usuario", unique: true
  add_index "cuenta_usuarios", ["rols_id"], name: "index_cuenta_usuarios_on_rols_id"
  add_index "cuenta_usuarios", ["tipo_documentos_id"], name: "index_cuenta_usuarios_on_tipo_documentos_id"

  create_table "dia_asociados", force: :cascade do |t|
    t.integer  "numero",                null: false
    t.string   "nombre",     limit: 15
    t.integer  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dia_asociados", ["nombre"], name: "index_nombre_dias_asociados", unique: true
  add_index "dia_asociados", ["numero"], name: "index_numero_dias_asociados", unique: true

  create_table "estado_civils", force: :cascade do |t|
    t.string   "nombre",     limit: 30
    t.integer  "estado",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "estado_civils", ["nombre"], name: "index_nombre_estado_civil", unique: true

  create_table "inr_pacientes", force: :cascade do |t|
    t.integer  "cita_medicas_id"
    t.integer  "anticoagulantes_id"
    t.date     "fecha",              null: false
    t.decimal  "valor_inr",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inr_pacientes", ["anticoagulantes_id"], name: "index_inr_pacientes_on_anticoagulantes_id"
  add_index "inr_pacientes", ["cita_medicas_id"], name: "index_inr_pacientes_on_cita_medicas_id"
  add_index "inr_pacientes", ["valor_inr", "fecha"], name: "index_fecha_inr", unique: true

  create_table "laboratorios", force: :cascade do |t|
    t.integer  "pacientes_id"
    t.date     "fecha",                   null: false
    t.string   "estudio",      limit: 50
    t.string   "resultado",    limit: 20
    t.text     "observacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "laboratorios", ["pacientes_id"], name: "index_laboratorios_on_pacientes_id"

  create_table "observacion_medicas", force: :cascade do |t|
    t.integer "respuesta_citas_id"
    t.text    "subjetivo"
    t.text    "objetivo"
    t.boolean "tiempo_indefinido",   null: false
    t.integer "semanas_tratamiento", null: false
  end

  add_index "observacion_medicas", ["respuesta_citas_id"], name: "index_observacion_medicas_on_respuesta_citas_id"
  add_index "observacion_medicas", ["respuesta_citas_id"], name: "index_observacion_respuesta", unique: true

  create_table "pacientes", force: :cascade do |t|
    t.integer "identificacion"
    t.integer "tipo_documentos_id"
    t.string  "nombre",             limit: 30
    t.string  "apellido",           limit: 30
    t.string  "correo_electronico"
    t.boolean "genero",                        null: false
    t.string  "direccion",          limit: 50
    t.integer "estado_civils_id"
    t.integer "patologias_id"
    t.integer "estado",                        null: false
  end

  add_index "pacientes", ["estado_civils_id"], name: "index_pacientes_on_estado_civils_id"
  add_index "pacientes", ["identificacion", "tipo_documentos_id"], name: "index_identificacion_tipo_documento_paciente", unique: true
  add_index "pacientes", ["patologias_id"], name: "index_pacientes_on_patologias_id"
  add_index "pacientes", ["tipo_documentos_id"], name: "index_pacientes_on_tipo_documentos_id"

  create_table "patologias", force: :cascade do |t|
    t.string   "nombre",      limit: 30
    t.text     "descripcion"
    t.integer  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patologias", ["nombre"], name: "index_nombre_patologias", unique: true

  create_table "pregunta_citas", force: :cascade do |t|
    t.integer "cita_medicas_id"
    t.integer "preguntas_id"
    t.text    "comentario"
  end

  add_index "pregunta_citas", ["cita_medicas_id", "preguntas_id"], name: "index_cita_preguntas", unique: true
  add_index "pregunta_citas", ["cita_medicas_id"], name: "index_pregunta_citas_on_cita_medicas_id"
  add_index "pregunta_citas", ["preguntas_id"], name: "index_pregunta_citas_on_preguntas_id"

  create_table "preguntas", force: :cascade do |t|
    t.string   "pregunta",    limit: 50
    t.text     "descripcion"
    t.integer  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preguntas", ["pregunta"], name: "index_pregunta_preguntas", unique: true

  create_table "prescripcion_diarias", force: :cascade do |t|
    t.integer "prescripcions_id"
    t.integer "dia_asociados_id"
    t.decimal "cantidad_gramo",   null: false
  end

  add_index "prescripcion_diarias", ["dia_asociados_id"], name: "index_prescripcion_diarias_on_dia_asociados_id"
  add_index "prescripcion_diarias", ["prescripcions_id", "dia_asociados_id"], name: "index_prescripcion_diaria", unique: true
  add_index "prescripcion_diarias", ["prescripcions_id"], name: "index_prescripcion_diarias_on_prescripcions_id"

  create_table "prescripcions", force: :cascade do |t|
    t.integer  "respuesta_citas_id"
    t.integer  "anticoagulantes_id"
    t.date     "fecha_final",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prescripcions", ["anticoagulantes_id"], name: "index_prescripcions_on_anticoagulantes_id"
  add_index "prescripcions", ["respuesta_citas_id"], name: "index_prescripcion_respuesta", unique: true
  add_index "prescripcions", ["respuesta_citas_id"], name: "index_prescripcions_on_respuesta_citas_id"

  create_table "respuesta_citas", force: :cascade do |t|
    t.integer "cita_medicas_id"
    t.integer "cuenta_usuarios_id"
    t.text    "analisis"
    t.text    "plan"
  end

  add_index "respuesta_citas", ["cita_medicas_id"], name: "index_cita_medica_respuesta", unique: true
  add_index "respuesta_citas", ["cita_medicas_id"], name: "index_respuesta_citas_on_cita_medicas_id"
  add_index "respuesta_citas", ["cuenta_usuarios_id"], name: "index_respuesta_citas_on_cuenta_usuarios_id"

  create_table "rols", force: :cascade do |t|
    t.string   "nombre",      limit: 30
    t.text     "descripcion"
    t.integer  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rols", ["nombre"], name: "index_nombre_roles", unique: true

  create_table "tipo_documentos", force: :cascade do |t|
    t.string   "nombre",     limit: 30
    t.integer  "estado",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tipo_documentos", ["nombre"], name: "index_nombre_tipo_documentos", unique: true

end
