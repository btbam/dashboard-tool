class CreateTestDashboardModels < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "dashboard_models", force: true do |t|
        t.decimal  "etl_row_id",                      null: false
        t.string   "model_id",           limit: 64,   null: false
        t.string   "name",               limit: 256,  null: false
        t.string   "description",        limit: 2048
        t.decimal  "is_numeric",                      null: false
        t.string   "frequency",          limit: 256
        t.string   "unit",               limit: 256
        t.decimal  "default_weight",                  null: false
        t.decimal  "is_composite_model",              null: false
        t.datetime "created_at",                      null: false
        t.datetime "updated_at",                      null: false
        t.datetime "start_scoring_at"
        t.datetime "stop_scoring_at"
        t.decimal  "dependency1_id"
        t.decimal  "dependency2_id"
        t.decimal  "dependency3_id"
        t.decimal  "dependency4_id"
        t.decimal  "dependency5_id"
        t.datetime "dashboard_created_at",                  null: false
        t.datetime "dashboard_updated_at",                  null: false
      end
    end
  end
end
