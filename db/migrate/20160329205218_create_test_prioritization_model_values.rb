class CreateTestDashboardModelValues < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "dashboard_model_values", force: true do |t|
        t.decimal  "etl_row_id",                       null: false
        t.decimal  "value_numeric"
        t.string   "value_character",       limit: 64
        t.datetime "score_effective_at",               null: false
        t.datetime "created_at",                       null: false
        t.datetime "updated_at",                       null: false
        t.decimal  "value_numeric_segment"
        t.string   "model_id",              limit: 64, null: false
        t.string   "dashboard_feature_id",                   null: false
        t.datetime "dashboard_created_at",                   null: false
        t.datetime "dashboard_updated_at",                   null: false
      end

      add_index "dashboard_model_values", ["dashboard_feature_id"], name: "t_2_idx_1"
      add_index "dashboard_model_values", ["model_id"], name: "t_2_idx_2"
    end
  end
end
