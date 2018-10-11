class CreateTestModelClaim < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "model_claim", primary_key: "etl_row_id", force: true do |t|
        t.timestamp "etl_proc_date",        limit: 6,    null: false
        t.string    "etl_curr_rec",         limit: 1,    null: false
        t.string    "model_id",             limit: 64,   null: false
        t.string    "model_id_short",       limit: 8,    null: false
        t.string    "model_name",           limit: 256,  null: false
        t.string    "model_descripton",     limit: 2048
        t.string    "is_numeric_model",     limit: 1,    null: false
        t.string    "frequency",            limit: 256,  null: false
        t.string    "unit",                 limit: 256
        t.string    "is_composite_model",   limit: 1,    null: false
        t.timestamp "scoring_starts_at",    limit: 6
        t.timestamp "scoring_stops_at",     limit: 6
        t.string    "score_model_dep1",     limit: 64
        t.string    "score_model_dep2",     limit: 64
        t.string    "score_model_dep3",     limit: 64
        t.string    "score_model_dep4",     limit: 64
        t.string    "score_model_dep5",     limit: 64
        t.timestamp "created_date",         limit: 6,    null: false
        t.timestamp "updated_date",         limit: 6,    null: false
        t.decimal   "attention_flag_value"
        t.string    "attention_reason",     limit: 2048
        t.string    "attention_recomm",     limit: 2048
      end
    end
  end
end
