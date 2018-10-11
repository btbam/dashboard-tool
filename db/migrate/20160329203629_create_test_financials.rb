class CreateTestFinancials < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "financials", force: true do |t|
        t.decimal  "branch_id"
        t.decimal  "case_id"
        t.string   "claim_id"
        t.decimal  "feature_id"
        t.string   "reserve_type"
        t.decimal  "base_transaction"
        t.datetime "sort_date"
        t.decimal  "transaction_id"
        t.datetime "process_date"
        t.datetime "entry_date"
        t.decimal  "paid_or_reserve_amount"
        t.decimal  "net_change_dollars"
        t.string   "financial_entry_operator"
      end

      add_index "financials", ["base_transaction"], name: "t_21_idx_1"
      add_index "financials", ["branch_id"], name: "t_21_idx_2"
      add_index "financials", ["case_id"], name: "t_21_idx_3"
      add_index "financials", ["claim_id"], name: "t_21_idx_4"
      add_index "financials", ["entry_date"], name: "t_21_idx_5"
      add_index "financials", ["feature_id"], name: "t_21_idx_6"
      add_index "financials", ["financial_entry_operator"], name: "t_21_idx_7"
      add_index "financials", ["process_date"], name: "t_21_idx_8"
      add_index "financials", ["reserve_type"], name: "t_21_idx_9"
      add_index "financials", ["sort_date"], name: "t_21_idx_10"
      add_index "financials", ["transaction_id"], name: "t_21_idx_11"
    end
  end
end
