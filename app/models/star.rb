class Star < ActiveRecord::Base
  belongs_to :user
  belongs_to :feature, primary_key: 'dashboard_compound_key'

  validates :user_id, uniqueness: { scope: :feature_id }
end
