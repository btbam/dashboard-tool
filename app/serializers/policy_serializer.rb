class PolicySerializer < ActiveModel::Serializer
  attributes :insured_name

  def insured_name
    object.insured_name_humanize
  end
end
