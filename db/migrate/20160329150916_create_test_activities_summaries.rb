class CreateTestActivitiesSummaries < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "activity_summaries", force: true do |t|
        t.string   "claim_id",               null: false
        t.decimal  "feature_id",             null: false
        t.string   "diary_scheduled_flag"
        t.datetime "diary_scheduled_date"
        t.decimal  "diary_scheduled_days"
        t.decimal  "branch_id",              null: false
        t.decimal  "case_number",            null: false
        t.decimal  "dashboard_database_unique_id", null: false
        t.string   "dashboard_compound_key",       null: false
        t.datetime "created_at",             null: false
        t.datetime "updated_at",             null: false
        t.string "author_id"
        t.string "author_type"
      end

      add_index "activity_summaries", ["dashboard_compound_key"], name: "t_51_idx_2"
      add_index "activity_summaries", ["case_number"], name: "t_51_idx_1"
    end
  end
end
