class CreateTestManagers < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "managers", force: true do |t|
        t.string   "manager_id"
        t.string   "name"
        t.string   "email"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "lan_id"
        t.decimal  "dashboard_claim_unique_id"
        t.decimal  "dashboard_claim_manager_unique_id"
      end

      add_index "managers", ["dashboard_claim_unique_id"], name: "t_23_idx_1"
      add_index "managers", ["lan_id"], name: "t_23_idx_2"
      add_index "managers", ["manager_id"], name: "t_23_idx_3"
      add_index "managers", ["name"], name: "t_23_idx_4"
    end
  end
end
