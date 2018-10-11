class NotificationSerializer < ActiveModel::Serializer
  attributes :notification_type, :notification_id, :triggering_user_id, :triggering_user, :id, :value, :created_at

  def triggering_user
    triggering_user = object.triggering_user
    if triggering_user
      { 'name' => triggering_user.full_name, 'email' => triggering_user.email }
    else
      { 'name' => 'N/A', 'email' => 'N/A' }
    end
  end

  def value
    object.notification.try(:value_character)
  end
end
