class CreateTestModelScoresClaim < ActiveRecord::Migration
  def change
    if Rails.env.test?
      create_table "model_scores_claim", id: false, force: true do |t|
        t.string    "attention_trigger",          limit: 1,  null: false
        t.decimal   "attention_trigger_adj_rank"
        t.decimal   "branch_cd",                             null: false
        t.decimal   "case_no",                               null: false
        t.string    "claim_id",                              null: false
        t.timestamp "created_at",                 limit: 6,  null: false
        t.string    "etl_curr_rec",               limit: 1,  null: false
        t.string    "etl_orig_rec",               limit: 1,  null: false
        t.timestamp "etl_proc_date",              limit: 6,  null: false
        t.decimal   "etl_row_id",                            null: false
        t.decimal   "feature_id",                            null: false
        t.string    "model_id",                   limit: 64, null: false
        t.string    "oc_claim_no",                limit: 20
        t.string    "oc_feature_no",              limit: 20
        t.decimal   "score_delta_orig"
        t.decimal   "score_delta_week"
        t.timestamp "score_effective_at",         limit: 6,  null: false
        t.decimal   "score_id",                              null: false
        t.decimal   "symbol",                                null: false
        t.timestamp "updated_at",                 limit: 6,  null: false
        t.string    "value_character",            limit: 64
        t.decimal   "value_numeric"
        t.decimal   "value_numeric_adj_rank"
        t.decimal   "value_numeric_segment"
      end

      add_index "model_scores_claim", ["attention_trigger"], name: "t_27_idx_4"
      add_index "model_scores_claim", ["attention_trigger_adj_rank"], name: "t_27_idx_5"
      add_index "model_scores_claim", ["branch_cd", "case_no", "symbol"], name: "t_27_idx_1"
      add_index "model_scores_claim", ["created_at"], name: "t_27_idx_9"
      add_index "model_scores_claim", ["etl_curr_rec"], name: "t_27_idx_6"
      add_index "model_scores_claim", ["etl_orig_rec"], name: "t_27_idx_7"
      add_index "model_scores_claim", ["etl_proc_date"], name: "t_27_idx_8"
      add_index "model_scores_claim", ["model_id"], name: "t_27_idx_12"
      add_index "model_scores_claim", ["oc_claim_no"], name: "t_27_idx_2"
      add_index "model_scores_claim", ["oc_feature_no"], name: "t_27_idx_3"
      add_index "model_scores_claim", ["value_numeric_adj_rank"], name: "t_27_idx_10"
      add_index "model_scores_claim", ["value_numeric_segment"], name: "t_27_idx_11"
    end
  end
end
