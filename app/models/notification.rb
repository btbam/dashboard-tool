class Notification < ActiveRecord::Base
  belongs_to :notification, polymorphic: true
  belongs_to :feature, primary_key: :dashboard_compound_key, foreign_key: :dashboard_compound_key
  belongs_to :target_user, primary_key: :id, foreign_key: :target_user_id, class_name: 'User'
  belongs_to :triggering_user, primary_key: :id, foreign_key: :triggering_user_id, class_name: 'User'

  scope :open, -> { where(complete: false) }
  scope :displayable, -> { where(deleted: false) }
  scope :by_dashboard_compound_key, ->(dashboard_compound_key) { where(dashboard_compound_key: dashboard_compound_key) }
  scope :by_target_user_id, ->(target_user_id) { where(target_user_id: target_user_id) }
end
