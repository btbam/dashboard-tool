class AdjusterSerializer < ActiveModel::Serializer
  attributes :id, :name, :manager_id, :email, :adjuster_id

  def name
    object.name.titleize
  end
end
