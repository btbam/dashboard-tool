class SchemaLoad < ActiveRecord::Migration
  def change
    create_table "active_admin_comments", force: true do |t|
      t.string   "namespace"
      t.string   "body",          limit: 4000
      t.string   "resource_id",                null: false
      t.string   "resource_type",              null: false
      t.decimal  "author_id"
      t.string   "author_type"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
    end

    add_index "active_admin_comments", ["author_type", "author_id"], name: "t_4_idx_2"
    add_index "active_admin_comments", ["namespace"], name: "t_4_idx_1"
    add_index "active_admin_comments", ["resource_type", "resource_id"], name: "t_4_idx_3"

    create_table "activity_summaries", force: true do |t|
      t.string   "claim_id",               null: false
      t.decimal  "feature_id",             null: false
      t.string   "diary_scheduled_flag"
      t.datetime "diary_scheduled_date"
      t.decimal  "diary_scheduled_days"
      t.decimal  "branch_id",              null: false
      t.decimal  "case_number",            null: false
      t.decimal  "dashboard_database_unique_id", null: false
      t.string   "dashboard_compound_key",       null: false
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end

    add_index "activity_summaries", ["dashboard_compound_key"], name: "t_51_idx_2"
    add_index "activity_summaries", ["case_number"], name: "t_51_idx_1"

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

    add_index "adjusters", ["adjuster_id"], name: "t_16_idx_1"
    add_index "adjusters", ["dashboard_claim_unique_id"], name: "t_16_idx_2"
    add_index "adjusters", ["claim_type"], name: "t_16_idx_3"
    add_index "adjusters", ["lan_id"], name: "t_16_idx_4"
    add_index "adjusters", ["manager_id"], name: "t_16_idx_5"
    add_index "adjusters", ["name"], name: "t_16_idx_6"

    create_table "alerts", force: true do |t|
      t.decimal  "level"
      t.text     "text",       null: false
      t.datetime "expires",    null: false
      t.datetime "created_at", null: false
      t.datetime "update_at",  null: false
    end

    add_index "alerts", ["expires"], name: "t_52_idx_1"

    create_table "cases", force: true do |t|
      t.decimal  "branch_id"
      t.decimal  "case_number"
      t.decimal  "policy_number"
      t.string   "primary_loss_desc"
      t.string   "secondary_loss_desc"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.decimal  "dashboard_database_unique_id"
      t.string   "dashboard_compound_key"
      t.datetime "receipt_date"
      t.decimal  "handling_office_id"
      t.string   "dashboard_policy_compound_key"
      t.decimal  "module_number"
      t.decimal  "ann_stmt_co"
      t.string   "case_type",               limit: 1
    end

    add_index "cases", ["dashboard_compound_key"], name: "t_18_idx_1"
    add_index "cases", ["dashboard_database_unique_id"], name: "t_18_idx_2"
    add_index "cases", ["dashboard_policy_compound_key"], name: "t_18_idx_3"
    add_index "cases", ["ann_stmt_co"], name: "t_18_idx_4"
    add_index "cases", ["case_number"], name: "t_18_idx_5"
    add_index "cases", ["handling_office_id"], name: "t_18_idx_6"
    add_index "cases", ["module_number"], name: "t_18_idx_7"
    add_index "cases", ["policy_number"], name: "t_18_idx_8"
    add_index "cases", ["receipt_date"], name: "t_18_idx_9"

    create_table "closed_features", primary_key: "false", force: true do |t|
      t.decimal "user_id",          null: false
      t.string  "dashboard_compound_key", null: false
    end

    add_index "closed_features", ["dashboard_compound_key"], name: "t_53_idx_1"
    add_index "closed_features", ["user_id"], name: "t_53_idx_2"

    create_table "diary_note_types", force: true do |t|
      t.string   "name",       null: false
      t.decimal  "display"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "diary_notes", force: true do |t|
      t.string   "dashboard_compound_key",                                         null: false
      t.decimal  "user_id",                                                  null: false
      t.text     "diary",                                                    null: false
      t.datetime "created_at",                                               null: false
      t.datetime "updated_at",                                               null: false
      t.boolean  "deleted",          precision: 1, scale: 0, default: false
    end

    create_table "diary_notes_diary_note_types", force: true do |t|
      t.decimal  "diary_note_id"
      t.decimal  "diary_note_type_id"
      t.datetime "created_at",         null: false
      t.datetime "updated_at",         null: false
    end

    add_index "diary_notes_diary_note_types", ["diary_note_id"], name: "t_56_idx_1"
    add_index "diary_notes_diary_note_types", ["diary_note_type_id"], name: "t_56_idx_2"

    create_table "feature_dates", force: true do |t|
      t.datetime "next_diary"
      t.datetime "due"
      t.string   "dashboard_compound_key", null: false
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
    end

    add_index "feature_dates", ["dashboard_compound_key"], name: "t_3_idx_1"

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
      t.decimal  "indemnity_paid"
      t.decimal  "legal_paid"
      t.decimal  "medical_paid"
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

    create_table "features_dashboard_models", force: true do |t|
      t.decimal  "feature_id"
      t.decimal  "dashboard_model_id"
      t.datetime "created_at",              null: false
      t.datetime "updated_at",              null: false
    end

    add_index "features_dashboard_models", ["feature_id"], name: "t_57_idx_1"

    create_table "feedbacks", force: true do |t|
      t.string   "feature_id"
      t.decimal  "user_id"
      t.text     "note"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.decimal  "priority"
    end

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

    create_table "hidden_columns", force: true do |t|
      t.string   "column_name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "display",     precision: 1, scale: 0, default: false
    end

    create_table "importer_runs", force: true do |t|
      t.text      "error_trace"
      t.timestamp "started_at",        limit: 6
      t.timestamp "completed_at",      limit: 6
      t.decimal   "duration"
      t.string    "importer_version"
      t.decimal   "records_created"
      t.decimal   "records_updated"
      t.text      "validation_errors"
      t.datetime  "created_at"
      t.datetime  "updated_at"
      t.string    "source_model"
      t.string    "destination_model"
    end

    add_index "importer_runs", ["completed_at"], name: "t_60_idx_1"
    add_index "importer_runs", ["destination_model"], name: "t_60_idx_2"
    add_index "importer_runs", ["importer_version"], name: "t_60_idx_3"
    add_index "importer_runs", ["source_model"], name: "t_60_idx_4"
    add_index "importer_runs", ["started_at"], name: "t_60_idx_5"

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

    create_table "notes", force: true do |t|
      t.string   "dashboard_application_id"
      t.string   "dashboard_claim_id"
      t.decimal  "claims_system"
      t.decimal  "dashboard_note_id"
      t.decimal  "revision_number"
      t.decimal  "segment_id"
      t.decimal  "processed"
      t.string   "note_title"
      t.text     "message"
      t.datetime "dashboard_updated_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.decimal  "dashboard_database_unique_id"
      t.string   "dashboard_unique_id"
      t.decimal  "author_id"
      t.string   "author_type"
      t.string   "dashboard_feature_id"
      t.string   "dashboard_user_name"
      t.string   "note_status_type"
      t.string   "note_type"
      t.string   "dashboard_author_id"
      t.datetime "dashboard_created_at"
      t.text     "original_message"
      t.string   "note_level"
      t.string   "note_category"
    end

    add_index "notes", ["dashboard_application_id"], name: "t_24_idx_1"
    add_index "notes", ["dashboard_claim_id"], name: "t_24_idx_2"
    add_index "notes", ["dashboard_created_at"], name: "t_24_idx_3"
    add_index "notes", ["dashboard_database_unique_id"], name: "t_24_idx_4"
    add_index "notes", ["dashboard_feature_id"], name: "t_24_idx_5"
    add_index "notes", ["dashboard_note_id"], name: "t_24_idx_6"
    add_index "notes", ["dashboard_unique_id"], name: "t_24_idx_7"
    add_index "notes", ["dashboard_updated_at"], name: "t_24_idx_8"
    add_index "notes", ["author_id"], name: "t_24_idx_9"
    add_index "notes", ["author_type"], name: "t_24_idx_10"
    add_index "notes", ["claims_system"], name: "t_24_idx_11"
    add_index "notes", ["note_level"], name: "t_24_idx_12"
    add_index "notes", ["processed"], name: "t_24_idx_13"

    create_table "notifications", force: true do |t|
      t.string   "notification_type"
      t.decimal  "notification_id"
      t.decimal  "complete"
      t.string   "dashboard_compound_key"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.decimal  "deleted"
      t.decimal  "target_user_id"
      t.decimal  "triggering_user_id"
    end

    add_index "notifications", ["dashboard_compound_key"], name: "t_61_idx_1"
    add_index "notifications", ["complete"], name: "t_61_idx_2"
    add_index "notifications", ["deleted"], name: "t_61_idx_3"
    add_index "notifications", ["notification_id"], name: "t_61_idx_4"
    add_index "notifications", ["notification_type"], name: "t_61_idx_5"
    add_index "notifications", ["target_user_id"], name: "t_61_idx_6"
    add_index "notifications", ["triggering_user_id"], name: "t_61_idx_7"
    add_index "notifications", ["updated_at"], name: "t_61_idx_8"

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

    create_table "dashboard_model_values", force: true do |t|
      t.decimal  "etl_row_id",                       null: false
      t.decimal  "value_numeric"
      t.string   "value_character",       limit: 64
      t.datetime "score_effective_at",               null: false
      t.datetime "created_at",                       null: false
      t.datetime "updated_at",                       null: false
      t.decimal  "value_numeric_segment"
      t.string   "model_id",              limit: 64, null: false
      t.string   "dashboard_feature_id",                   null: false
      t.datetime "dashboard_created_at",                   null: false
      t.datetime "dashboard_updated_at",                   null: false
    end

    add_index "dashboard_model_values", ["dashboard_feature_id"], name: "t_2_idx_1"
    add_index "dashboard_model_values", ["model_id"], name: "t_2_idx_2"

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

    create_table "role_permissions", force: true do |t|
      t.decimal  "user_id"
      t.decimal  "role_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles", force: true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "sign_in_timestamps", force: true do |t|
      t.decimal "user_id"
      t.decimal "time"
    end

    add_index "sign_in_timestamps", ["user_id"], name: "t_68_idx_1"

    create_table "stars", force: true do |t|
      t.string   "feature_id"
      t.decimal  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "stars", ["feature_id"], name: "t_66_idx_1"
    add_index "stars", ["user_id"], name: "t_66_idx_2"

    create_table "user_hidden_columns", force: true do |t|
      t.decimal  "user_id"
      t.decimal  "hidden_column_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "display",          precision: 1, scale: 0, default: false
    end

    add_index "user_hidden_columns", ["hidden_column_id"], name: "t_67_idx_1"
    add_index "user_hidden_columns", ["user_id"], name: "t_67_idx_2"

    create_table "users", force: true do |t|
      t.string   "login"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          precision: 38, scale: 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "email"
      t.string   "encrypted_password"
      t.string   "authentication_token"
      t.string   "dashboard_adjuster_id"
      t.string   "dashboard_manager_id"
      t.string   "name_last"
      t.string   "name_first"
      t.string   "dashboard_lan_id"
      t.string   "dashboard_lan_domain"
      t.integer  "finished_registration",  precision: 38, scale: 0
      t.datetime "reset_password_sent_at"
      t.string   "reset_password_token"
    end

    add_index "users", ["authentication_token"], name: "t_65_idx_4"
    add_index "users", ["email"], name: "t_65_idx_5"
    add_index "users", ["login"], name: "t_65_idx_6"
  end
end
