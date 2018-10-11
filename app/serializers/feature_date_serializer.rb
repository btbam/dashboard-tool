class FeatureDateSerializer < ActiveModel::Serializer
  attributes :due, :created_at, :feature_id, :role_name

  def feature_id
    object.dashboard_compound_key
  end
end
