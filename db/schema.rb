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

ActiveRecord::Schema.define(version: 20150729220229) do

  create_table "antecedente_medicos", force: :cascade do |t|
    t.string   "nombre",      limit: 50
    t.string   "descripcion", limit: 30
    t.boolean  "tipo"
    t.integer  "estado",      limit: 4
    t.string   "tag",         limit: 30
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "antecedente_medicos", ["nombre"], name: "index_nombre_antecedentes_medicos", unique: true, using: :btree
  add_index "antecedente_medicos", ["tag", "estado"], name: "index_estado_tags_medicos", unique: true, using: :btree

  create_table "antecedente_pacientes", force: :cascade do |t|
    t.integer  "pacientes_id",           limit: 4
    t.integer  "antecedente_medicos_id", limit: 4
    t.text     "comentario",             limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "antecedente_pacientes", ["antecedente_medicos_id"], name: "index_antecedente_pacientes_on_antecedente_medicos_id", using: :btree
  add_index "antecedente_pacientes", ["pacientes_id", "antecedente_medicos_id"], name: "index_pacientes_antecedentes_medicos", unique: true, using: :btree
  add_index "antecedente_pacientes", ["pacientes_id"], name: "index_antecedente_pacientes_on_pacientes_id", using: :btree

  create_table "anticoagulantes", force: :cascade do |t|
    t.string   "nombre",        limit: 100
    t.integer  "estado",        limit: 4
    t.integer  "concentracion", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "anticoagulantes", ["nombre"], name: "index_nombre_anticoagulantes", unique: true, using: :btree

  create_table "cita_icds", force: :cascade do |t|
    t.integer  "icds_id",         limit: 4
    t.integer  "cita_medicas_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "cita_icds", ["cita_medicas_id"], name: "index_cita_icds_on_cita_medicas_id", using: :btree
  add_index "cita_icds", ["icds_id", "cita_medicas_id"], name: "index_icd_cita_medica", unique: true, using: :btree
  add_index "cita_icds", ["icds_id"], name: "index_cita_icds_on_icds_id", using: :btree

  create_table "cita_medicas", force: :cascade do |t|
    t.integer  "pacientes_id",       limit: 4
    t.integer  "cuenta_usuarios_id", limit: 4
    t.date     "fecha"
    t.string   "tipo",               limit: 20
    t.integer  "estado",             limit: 4
    t.time     "hora_ini"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "generico",                      default: false
    t.date     "fecha_realizacion"
  end

  add_index "cita_medicas", ["cuenta_usuarios_id", "fecha", "hora_ini"], name: "index_usuario_fecha_hora_cita", unique: true, using: :btree
  add_index "cita_medicas", ["cuenta_usuarios_id"], name: "index_cita_medicas_on_cuenta_usuarios_id", using: :btree
  add_index "cita_medicas", ["pacientes_id", "fecha", "hora_ini"], name: "index_paciente_fecha_hora_cita", unique: true, using: :btree
  add_index "cita_medicas", ["pacientes_id"], name: "index_cita_medicas_on_pacientes_id", using: :btree

  create_table "cuenta_usuarios", force: :cascade do |t|
    t.string   "identificacion",         limit: 255
    t.integer  "tipo_documentos_id",     limit: 4
    t.string   "nombre",                 limit: 30
    t.string   "apellido",               limit: 30
    t.string   "email",                  limit: 50,  default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.boolean  "genero"
    t.string   "direccion",              limit: 100
    t.string   "especialidad",           limit: 50
    t.date     "fecha_nacimiento"
    t.integer  "estado",                 limit: 4
    t.integer  "rols_id",                limit: 4
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.boolean  "encargado_respuesta",                default: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "link_foto",              limit: 100
    t.string   "provider",               limit: 50
    t.string   "uid",                    limit: 50       
    t.date     "ultimoLogin"
  end

  add_index "cuenta_usuarios", ["email"], name: "index_correo_usuarios", unique: true, using: :btree
  add_index "cuenta_usuarios", ["identificacion", "tipo_documentos_id"], name: "index_identificacion_documento_usuario", unique: true, using: :btree
  add_index "cuenta_usuarios", ["rols_id"], name: "index_cuenta_usuarios_on_rols_id", using: :btree
  add_index "cuenta_usuarios", ["tipo_documentos_id"], name: "index_cuenta_usuarios_on_tipo_documentos_id", using: :btree

  create_table "dia_asociados", force: :cascade do |t|
    t.integer  "numero",     limit: 4
    t.string   "nombre",     limit: 15
    t.integer  "estado",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "dia_asociados", ["nombre"], name: "index_nombre_dias_asociados", unique: true, using: :btree
  add_index "dia_asociados", ["numero"], name: "index_numero_dias_asociados", unique: true, using: :btree

  create_table "estado_civils", force: :cascade do |t|
    t.string   "nombre",     limit: 30
    t.integer  "estado",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "estado_civils", ["nombre"], name: "index_nombre_estado_civil", unique: true, using: :btree

  create_table "horario_usuarios", force: :cascade do |t|
    t.integer  "cuenta_usuarios_id", limit: 4
    t.integer  "dia_asignados_id",   limit: 4
    t.integer  "sucursals_id",       limit: 4
    t.time     "hora_inicial"
    t.time     "hora_final"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "horario_usuarios", ["cuenta_usuarios_id", "dia_asignados_id"], name: "index_horario_usuario_dia", unique: true, using: :btree
  add_index "horario_usuarios", ["cuenta_usuarios_id"], name: "index_horario_usuarios_on_cuenta_usuarios_id", using: :btree
  add_index "horario_usuarios", ["dia_asignados_id"], name: "index_horario_usuarios_on_dia_asignados_id", using: :btree
  add_index "horario_usuarios", ["sucursals_id"], name: "index_horario_usuarios_on_sucursals_id", using: :btree

  create_table "icds", force: :cascade do |t|
    t.string   "id10",       limit: 6
    t.string   "dec10",      limit: 80
    t.string   "grp10",      limit: 10
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "inr_pacientes", force: :cascade do |t|
    t.integer  "cita_medicas_id",    limit: 4
    t.date     "fecha"
    t.decimal  "valorInr",                     precision: 4, scale: 2
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "inr_pacientes", ["cita_medicas_id"], name: "index_inr_pacientes_on_cita_medicas_id", using: :btree

  create_table "laboratorios", force: :cascade do |t|
    t.integer  "pacientes_id", limit: 4
    t.date     "fecha"
    t.string   "estudio",      limit: 250
    t.string   "resultado",    limit: 250
    t.text     "observacion",  limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "laboratorios", ["pacientes_id"], name: "index_laboratorios_on_pacientes_id", using: :btree

  create_table "observacion_medicas", force: :cascade do |t|
    t.integer  "cita_medicas_id",   limit: 4
    t.text     "obDos",           limit: 65535
    t.text     "obUno",            limit: 65535
    t.boolean  "tiempoIndefinido"
    t.integer  "diasTratamiento",     limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "frecuencia_cardiaca", limit: 4
    t.integer  "hiper_sistolica",     limit: 4
    t.integer  "hiper_diastolica",    limit: 4
  end

  add_index "observacion_medicas", ["cita_medicas_id"], name: "index_observacion_medicas_on_cita_medicas_id", unique: true, using: :btree

  create_table "pacientes", force: :cascade do |t|
    t.string   "identificacion",      limit: 30
    t.integer  "tipo_documentos_id",  limit: 4
    t.string   "nombre",              limit: 30
    t.string   "apellido",            limit: 30
    t.string   "correo",              limit: 45
    t.boolean  "genero"
    t.date     "fecha_nacimiento"
    t.string   "direccion",           limit: 100
    t.integer  "estado_civils_id",    limit: 4
    t.integer  "patologia_id",        limit: 4
    t.integer  "estado",              limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.text     "antecedente_general", limit: 65535
    t.string   "ttrCacTotal",         limit: 4
    t.string   "ttrCacDoceM",         limit: 4
    t.string   "ttrCacSeisM",         limit: 4
    t.string   "ttrCacPrevio",        limit: 4
  end

  add_index "pacientes", ["estado_civils_id"], name: "index_pacientes_on_estado_civils_id", using: :btree
  add_index "pacientes", ["identificacion", "tipo_documentos_id"], name: "index_identificacion_tipo_documento_paciente", unique: true, using: :btree
  add_index "pacientes", ["patologia_id"], name: "index_pacientes_on_patologia_id", using: :btree
  add_index "pacientes", ["tipo_documentos_id"], name: "index_pacientes_on_tipo_documentos_id", using: :btree

  create_table "patologia", force: :cascade do |t|
    t.string   "nombre",      limit: 30
    t.string   "descripcion", limit: 50
    t.integer  "estado",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "patologia", ["nombre"], name: "index_nombre_patologias", unique: true, using: :btree

  create_table "pregunta", force: :cascade do |t|
    t.string   "pregunta",    limit: 50
    t.string   "descripcion", limit: 20
    t.integer  "estado",      limit: 4
    t.boolean  "tipo"
    t.string   "tag",         limit: 20
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "pregunta", ["pregunta"], name: "index_pregunta_preguntas", unique: true, using: :btree
  add_index "pregunta", ["tag", "estado"], name: "index_tag_estado_pregunta", unique: true, using: :btree

  create_table "pregunta_cita", force: :cascade do |t|
    t.integer  "cita_medicas_id", limit: 4
    t.integer  "pregunta_id",     limit: 4
    t.text     "comentario",      limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "pregunta_cita", ["cita_medicas_id", "pregunta_id"], name: "index_cita_preguntas", unique: true, using: :btree
  add_index "pregunta_cita", ["cita_medicas_id"], name: "index_pregunta_cita_on_cita_medicas_id", using: :btree
  add_index "pregunta_cita", ["pregunta_id"], name: "index_pregunta_cita_on_pregunta_id", using: :btree

  create_table "prescripcion_diaria", force: :cascade do |t|
    t.integer  "prescripcions_id", limit: 4
    t.integer  "dia_asociados_id", limit: 4
    t.decimal  "dosis",                     precision: 4, scale: 2
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "prescripcion_diaria", ["dia_asociados_id"], name: "index_prescripcion_diaria_on_dia_asociados_id", using: :btree
  add_index "prescripcion_diaria", ["prescripcions_id", "dia_asociados_id"], name: "index_prescripcion_diaria", unique: true, using: :btree
  add_index "prescripcion_diaria", ["prescripcions_id"], name: "index_prescripcion_diaria_on_prescripcions_id", using: :btree

  create_table "prescripcions", force: :cascade do |t|
    t.integer  "respuesta_cita_id",  limit: 4
    t.integer  "anticoagulantes_id", limit: 4
    t.date     "fechaFin"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "recomendacion",      limit: 255
    t.string   "dosisSemanal",       limit: 4
  end

  add_index "prescripcions", ["anticoagulantes_id"], name: "index_prescripcions_on_anticoagulantes_id", using: :btree
  add_index "prescripcions", ["respuesta_cita_id"], name: "index_prescripcions_on_respuesta_cita_id", unique: true, using: :btree

  create_table "respuesta_cita", force: :cascade do |t|
    t.integer  "cita_medicas_id",    limit: 4
    t.integer  "cuenta_usuarios_id", limit: 4
    t.text     "analisis",           limit: 65535
    t.text     "plan",               limit: 65535
    t.integer  "estado",             limit: 4
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.decimal  "valor_min",                        precision: 4, scale: 2
    t.decimal  "valor_max",                        precision: 4, scale: 2
  end

  add_index "respuesta_cita", ["cita_medicas_id"], name: "index_respuesta_cita_on_cita_medicas_id", unique: true, using: :btree
  add_index "respuesta_cita", ["cuenta_usuarios_id"], name: "index_respuesta_cita_on_cuenta_usuarios_id", using: :btree

  create_table "rols", force: :cascade do |t|
    t.string   "nombre",      limit: 20
    t.string   "descripcion", limit: 50
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "rols", ["nombre"], name: "index_nombre_roles", unique: true, using: :btree

  create_table "sucursals", force: :cascade do |t|
    t.string   "nombre",     limit: 45
    t.string   "direccion",  limit: 50
    t.integer  "estado",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "sucursals", ["nombre"], name: "index_sucursals_on_nombre", unique: true, using: :btree

  create_table "tipo_documentos", force: :cascade do |t|
    t.string   "nombre",     limit: 40
    t.integer  "estado",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "tipo_documentos", ["nombre"], name: "index_nombre_tipo_documentos", unique: true, using: :btree

end
