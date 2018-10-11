class CreateTestPolicies < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "policies", force: true do |t|
        t.decimal  "policy_number"
        t.decimal  "module_number"
        t.string   "policy_prefix"
        t.decimal  "issuing_company"
        t.decimal  "producer_number"
        t.string   "insured_name"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.datetime "effective_date"
        t.datetime "expiration_date"
        t.decimal  "dashboard_database_unique_id"
        t.string   "dashboard_compound_key"
        t.decimal  "ann_stmt_co"
      end

      add_index "policies", ["dashboard_compound_key"], name: "t_25_idx_1"
      add_index "policies", ["dashboard_database_unique_id"], name: "t_25_idx_2"
      add_index "policies", ["ann_stmt_co"], name: "t_25_idx_3"
      add_index "policies", ["effective_date"], name: "t_25_idx_4"
      add_index "policies", ["expiration_date"], name: "t_25_idx_5"
      add_index "policies", ["insured_name"], name: "t_25_idx_6"
      add_index "policies", ["module_number"], name: "t_25_idx_7"
      add_index "policies", ["policy_number"], name: "t_25_idx_8"
    end
  end
end
