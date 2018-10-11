class CreateTestFeatureDashboard < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "features_dashboard_models", force: true do |t|
        t.decimal  "feature_id"
        t.decimal  "dashboard_model_id"
        t.datetime "created_at",              null: false
        t.datetime "updated_at",              null: false
      end

      add_index "features_dashboard_models", ["feature_id"], name: "t_57_idx_1"
    end
  end
end
