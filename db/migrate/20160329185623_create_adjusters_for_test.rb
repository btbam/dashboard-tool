class CreateAdjustersForTest < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "adjusters", force: true do |t|
        t.string   "adjuster_id"
        t.string   "op_id"
        t.string   "name"
        t.string   "manager_id"
        t.string   "email"
        t.string   "title"
        t.decimal  "claim_type"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "lan_id"
        t.decimal  "dashboard_claim_unique_id"
        t.decimal  "dashboard_claim_manager_unique_id"
      end

      change_column :adjusters, :id, :decimal
      add_index "adjusters", ["adjuster_id"], name: "t_16_idx_1"
      add_index "adjusters", ["dashboard_claim_unique_id"], name: "t_16_idx_2"
      add_index "adjusters", ["claim_type"], name: "t_16_idx_3"
      add_index "adjusters", ["lan_id"], name: "t_16_idx_4"
      add_index "adjusters", ["manager_id"], name: "t_16_idx_5"
      add_index "adjusters", ["name"], name: "t_16_idx_6"
    end
  end
end
