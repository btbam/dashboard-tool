class CreateTestCases < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "cases", force: true do |t|
        t.decimal  "branch_id"
        t.decimal  "case_number"
        t.decimal  "policy_number"
        t.string   "primary_loss_desc"
        t.string   "secondary_loss_desc"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.decimal  "dashboard_database_unique_id"
        t.string   "dashboard_compound_key"
        t.datetime "receipt_date"
        t.decimal  "handling_office_id"
        t.string   "dashboard_policy_compound_key"
        t.decimal  "module_number"
        t.decimal  "ann_stmt_co"
        t.string   "case_type",               limit: 1
      end

      add_index "cases", ["dashboard_compound_key"], name: "t_18_idx_1"
      add_index "cases", ["dashboard_database_unique_id"], name: "t_18_idx_2"
      add_index "cases", ["dashboard_policy_compound_key"], name: "t_18_idx_3"
      add_index "cases", ["ann_stmt_co"], name: "t_18_idx_4"
      add_index "cases", ["case_number"], name: "t_18_idx_5"
      add_index "cases", ["handling_office_id"], name: "t_18_idx_6"
      add_index "cases", ["module_number"], name: "t_18_idx_7"
      add_index "cases", ["policy_number"], name: "t_18_idx_8"
      add_index "cases", ["receipt_date"], name: "t_18_idx_9"
    end
  end
end
