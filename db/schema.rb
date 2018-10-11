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

ActiveRecord::Schema.define(version: 20160203212411) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.string   "body",          limit: 4000
    t.string   "resource_id",                null: false
    t.string   "resource_type",              null: false
    t.decimal  "author_id"
    t.string   "author_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "t_4_idx_2"
  add_index "active_admin_comments", ["namespace"], name: "t_4_idx_1"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "t_4_idx_3"

  create_table "alerts", force: true do |t|
    t.decimal  "level"
    t.text     "text",       null: false
    t.datetime "expires",    null: false
    t.datetime "created_at", null: false
    t.datetime "update_at",  null: false
  end

  add_index "alerts", ["expires"], name: "t_52_idx_1"

  create_table "closed_features", primary_key: "false", force: true do |t|
    t.decimal "user_id",          null: false
    t.string  "dashboard_compound_key", null: false
  end

  add_index "closed_features", ["dashboard_compound_key"], name: "t_53_idx_1"
  add_index "closed_features", ["user_id"], name: "t_53_idx_2"

  create_table "diary_note_types", force: true do |t|
    t.string   "name",       null: false
    t.decimal  "display"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diary_notes", force: true do |t|
    t.string   "dashboard_compound_key",                                         null: false
    t.decimal  "user_id",                                                  null: false
    t.text     "diary",                                                    null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.boolean  "deleted",          precision: 1, scale: 0, default: false
  end

  create_table "diary_notes_diary_note_types", force: true do |t|
    t.decimal  "diary_note_id"
    t.decimal  "diary_note_type_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "diary_notes_diary_note_types", ["diary_note_id"], name: "t_56_idx_1"
  add_index "diary_notes_diary_note_types", ["diary_note_type_id"], name: "t_56_idx_2"

  create_table "feature_dates", force: true do |t|
    t.datetime "next_diary"
    t.datetime "due"
    t.string   "dashboard_compound_key", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "feature_dates", ["dashboard_compound_key"], name: "t_3_idx_1"

  create_table "feedbacks", force: true do |t|
    t.string   "feature_id"
    t.decimal  "user_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "priority"
  end

  create_table "hidden_columns", force: true do |t|
    t.string   "column_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display",     precision: 1, scale: 0, default: false
  end

  create_table "importer_runs", force: true do |t|
    t.text      "error_trace"
    t.timestamp "started_at",        limit: 6
    t.timestamp "completed_at",      limit: 6
    t.decimal   "duration"
    t.string    "importer_version"
    t.decimal   "records_created"
    t.decimal   "records_updated"
    t.text      "validation_errors"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "source_model"
    t.string    "destination_model"
  end

  add_index "importer_runs", ["completed_at"], name: "t_60_idx_1"
  add_index "importer_runs", ["destination_model"], name: "t_60_idx_2"
  add_index "importer_runs", ["importer_version"], name: "t_60_idx_3"
  add_index "importer_runs", ["source_model"], name: "t_60_idx_4"
  add_index "importer_runs", ["started_at"], name: "t_60_idx_5"

  create_table "role_permissions", force: true do |t|
    t.decimal  "user_id"
    t.decimal  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sign_in_timestamps", force: true do |t|
    t.decimal "user_id"
    t.decimal "time"
  end

  add_index "sign_in_timestamps", ["user_id"], name: "t_68_idx_1"

  create_table "user_hidden_columns", force: true do |t|
    t.decimal  "user_id"
    t.decimal  "hidden_column_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display",          precision: 1, scale: 0, default: false
  end

  add_index "user_hidden_columns", ["hidden_column_id"], name: "t_67_idx_1"
  add_index "user_hidden_columns", ["user_id"], name: "t_67_idx_2"

  create_table "users", force: true do |t|
    t.string   "login"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          precision: 38, scale: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "authentication_token"
    t.string   "dashboard_adjuster_id"
    t.string   "dashboard_manager_id"
    t.string   "name_last"
    t.string   "name_first"
    t.string   "dashboard_lan_id"
    t.string   "dashboard_lan_domain"
    t.integer  "finished_registration",  precision: 38, scale: 0
    t.datetime "reset_password_sent_at"
    t.string   "reset_password_token"
  end

  add_index "users", ["authentication_token"], name: "t_65_idx_4"
  add_index "users", ["email"], name: "t_65_idx_5"
  add_index "users", ["login"], name: "t_65_idx_6"

end
