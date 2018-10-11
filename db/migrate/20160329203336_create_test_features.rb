class CreateTestFeatures < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "features", force: true do |t|
        t.string   "claim_id"
        t.decimal  "feature_id"
        t.decimal  "claims_system"
        t.datetime "feature_created"
        t.datetime "process_date"
        t.datetime "receipt_date"
        t.string   "claimant_name"
        t.decimal  "branch_id"
        t.decimal  "case_id"
        t.string   "current_adjuster"
        t.string   "major_class_type"
        t.decimal  "major_class_id"
        t.decimal  "in_suit"
        t.datetime "close_date"
        t.datetime "loss_date"
        t.string   "claim_status",           limit: 1
        t.datetime "created_at"
        t.datetime "updated_at"
        t.decimal  "indemnity_outstanding"
        t.decimal  "legal_outstanding"
        t.decimal  "medical_outstanding"
        t.decimal  "dashboard_database_unique_id"
        t.string   "dashboard_compound_key"
        t.string   "dashboard_case_compound_key"
        t.string   "dashboard_type_id"
        t.decimal  "dashboard_unique_feature_id"
        t.string   "loss_acc_st_prov",       limit: 8
        t.string   "loss_acc_st_prov_desc",  limit: 256
        t.string   "country",                limit: 12
        t.string   "state",                  limit: 8
        t.string   "state_desc",             limit: 256
        t.integer  "indemnity_paid",                     precision: 38, scale: 0
        t.integer  "legal_paid",                         precision: 38, scale: 0
        t.integer  "medical_paid",                       precision: 38, scale: 0
      end

      add_index "features", ["dashboard_case_compound_key"], name: "t_20_idx_1"
      add_index "features", ["dashboard_compound_key"], name: "t_20_idx_2"
      add_index "features", ["dashboard_database_unique_id"], name: "t_20_idx_3"
      add_index "features", ["dashboard_unique_feature_id"], name: "t_20_idx_4"
      add_index "features", ["claim_id"], name: "t_20_idx_5"
      add_index "features", ["claimant_name"], name: "t_20_idx_6"
      add_index "features", ["claims_system"], name: "t_20_idx_7"
      add_index "features", ["feature_created"], name: "t_20_idx_8"
      add_index "features", ["feature_id"], name: "t_20_idx_9"
    end
  end
end
