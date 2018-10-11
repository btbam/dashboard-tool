class ModelScore < DashboardRecord
  self.table_name = 'model_scores_claim'

  def create_notification
    existing_notifications = Notification.where(notification: self)
    return unless existing_notifications.empty?
    dashboard_compound_key = [branch_cd, case_no, feature_id].join('-')
    notification_feature = Feature.find_by(dashboard_compound_key: dashboard_compound_key)
    return unless notification_feature
    adjuster = User.find_by(dashboard_adjuster_id: notification_feature.current_adjuster)
    return unless adjuster
    Notification.create(notification: self, dashboard_compound_key: dashboard_compound_key, target_user_id: adjuster.id)
  end
end
