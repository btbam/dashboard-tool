class CreateTestNotes < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "notes", force: true do |t|
        t.string   "dashboard_application_id"
        t.string   "dashboard_claim_id"
        t.decimal  "claims_system"
        t.decimal  "dashboard_note_id"
        t.decimal  "revision_number"
        t.decimal  "segment_id"
        t.decimal  "processed"
        t.string   "note_title"
        t.text     "message"
        t.datetime "dashboard_updated_at"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.decimal  "dashboard_database_unique_id"
        t.string   "dashboard_unique_id"
        t.decimal  "author_id"
        t.string   "author_type"
        t.string   "dashboard_feature_id"
        t.string   "dashboard_user_name"
        t.string   "note_status_type"
        t.string   "note_type"
        t.string   "dashboard_author_id"
        t.datetime "dashboard_created_at"
        t.text     "original_message"
        t.string   "note_level"
        t.string   "note_category"
      end

      add_index "notes", ["dashboard_application_id"], name: "t_24_idx_1"
      add_index "notes", ["dashboard_claim_id"], name: "t_24_idx_2"
      add_index "notes", ["dashboard_created_at"], name: "t_24_idx_3"
      add_index "notes", ["dashboard_database_unique_id"], name: "t_24_idx_4"
      add_index "notes", ["dashboard_feature_id"], name: "t_24_idx_5"
      add_index "notes", ["dashboard_note_id"], name: "t_24_idx_6"
      add_index "notes", ["dashboard_unique_id"], name: "t_24_idx_7"
      add_index "notes", ["dashboard_updated_at"], name: "t_24_idx_8"
      add_index "notes", ["author_id"], name: "t_24_idx_9"
      add_index "notes", ["author_type"], name: "t_24_idx_10"
      add_index "notes", ["claims_system"], name: "t_24_idx_11"
      add_index "notes", ["note_level"], name: "t_24_idx_12"
      add_index "notes", ["processed"], name: "t_24_idx_13"
    end
  end
end
