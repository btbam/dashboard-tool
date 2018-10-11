class ClosedFeatureHabtmFix < ActiveRecord::Migration
  def change
    create_table "closed_features_new", force: true do |t|
      t.decimal "false"
      t.decimal "user_id",          null: false
      t.string  "dashboard_compound_key", null: false
    end


    add_index "closed_features_new", ["dashboard_compound_key"]
    add_index "closed_features_new", ["false"]
    add_index "closed_features_new", ["user_id"]
    execute "delete from closed_features where false is null"

    if column_exists?(:closed_features, :id)
      execute "insert into closed_features_new (id, false, user_id, dashboard_compound_key) select false, false, user_id, dashboard_compound_key from closed_features"
      drop_table :closed_features
      execute "ALTER TABLE closed_features_new RENAME TO closed_features"
      execute "CREATE SEQUENCE CLOSED_FEATURES_SEQ
               MINVALUE 1
               MAXVALUE 1000000000000000000000000000
               START WITH 200
               INCREMENT BY 1
               CACHE 20"
    else
      execute 'insert into closed_features_new ("false", user_id, dashboard_compound_key) select 0, user_id, dashboard_compound_key from closed_features'
      drop_table :closed_features
      execute "ALTER TABLE closed_features_new RENAME TO closed_features"
    end
  end
end
