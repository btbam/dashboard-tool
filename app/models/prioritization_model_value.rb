class DashboardModelValue < ActiveRecord::Base
  belongs_to :dashboard_model, foreign_key: :model_id, primary_key: :model_id
  belongs_to :feature, foreign_key: :dashboard_feature_id, primary_key: :dashboard_compound_key
end
