class AddRoleNameToFeatureDate < ActiveRecord::Migration
  def change
    add_column :feature_dates, :role_name, :string
  end
end
