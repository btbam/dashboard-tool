class DiaryNoteDance < ActiveRecord::Migration
  def change
    create_table "diary_notes_bak", force: true do |t|
      t.string   "dashboard_compound_key",                                          null: false
      t.integer  "user_id",          precision: 38, scale: 0,                 null: false
      t.text     "diary",                                                     null: false
      t.datetime "created_at",                                                null: false
      t.datetime "updated_at",                                                null: false
      t.boolean  "deleted",          precision: 1,  scale: 0, default: false
    end

    execute "insert into diary_notes_bak select * from diary_notes"

    drop_table :diary_notes

    create_table "diary_notes", force: true do |t|
      t.string   "dashboard_compound_key",                                          null: false
      t.integer  "user_id",          precision: 38, scale: 0,                 null: false
      t.text     "diary",                                                     null: false
      t.datetime "created_at",                                                null: false
      t.datetime "updated_at",                                                null: false
      t.boolean  "deleted",          precision: 1,  scale: 0, default: false
    end

    begin
      add_index "diary_notes", ["dashboard_compound_key"], name: "i_diary_notes_dashboard_compound_key", tablespace: "bfts_dashboard_live"
      add_index "diary_notes", ["deleted"], name: "index_diary_notes_on_deleted", tablespace: "bfts_dashboard_live"
      add_index "diary_notes", ["updated_at"], name: "i_diary_notes_updated_at", tablespace: "bfts_dashboard_live"
      add_index "diary_notes", ["user_id"], name: "index_diary_notes_on_user_id", tablespace: "bfts_dashboard_live"

      execute "insert into diary_notes select * from diary_notes_bak"

      drop_table :diary_notes_bak

      execute "drop sequence DIARY_NOTES_SEQ"

      execute "CREATE SEQUENCE DIARY_NOTES_SEQ
               MINVALUE 1
               MAXVALUE 1000000000000000000000000000
               START WITH 10500
               INCREMENT BY 1
               CACHE 20"
    rescue
      add_index "diary_notes", ["dashboard_compound_key"]
      add_index "diary_notes", ["deleted"]
      add_index "diary_notes", ["updated_at"]
      add_index "diary_notes", ["user_id"]

      execute "insert into diary_notes select * from diary_notes_bak"

      drop_table :diary_notes_bak
    end
  end
end
