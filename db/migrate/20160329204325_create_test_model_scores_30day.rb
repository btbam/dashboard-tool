class CreateTestModelScores30day < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "model_scores_30day_history", id: false, force: true do |t|
        t.decimal   "branch_cd",                             null: false
        t.decimal   "case_no",                               null: false
        t.decimal   "symbol",                                null: false
        t.string    "attention_trigger",          limit: 1,  null: false
        t.string    "value_character",            limit: 64
        t.string    "model_id",                   limit: 64, null: false
        t.decimal   "value_numeric"
        t.decimal   "value_numeric_segment"
        t.decimal   "score_delta_orig"
        t.decimal   "score_delta_week"
        t.timestamp "created_at",                 limit: 6,  null: false
        t.timestamp "etl_proc_date",              limit: 6,  null: false
        t.string    "oc_claim_no",                limit: 20
        t.string    "oc_feature_no",              limit: 20
        t.string    "dashboard_claim_id",                       null: false
        t.decimal   "value_numeric_adj_rank"
        t.decimal   "attention_trigger_adj_rank"
        t.timestamp "score_date",                 limit: 6,  null: false
        t.decimal   "daysopen"
        t.string    "adjustor_no",                           null: false
        t.string    "adjustor_name",                         null: false
        t.string    "manager_no"
        t.string    "manager_name",                          null: false
        t.string    "adjustor_class",                        null: false
      end
    end
  end
end
