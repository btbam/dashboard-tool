class NotificationDetailSerializer < NotificationSerializer
  attributes :object_type

  def object_type
    object.class.name
  end
end
