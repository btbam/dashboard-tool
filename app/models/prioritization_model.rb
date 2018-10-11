class DashboardModel < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :dashboard_model_values, foreign_key: :model_id, primary_key: :model_id
end
