class CaseSerializer < ActiveModel::Serializer
  attributes :receipt_date

  has_one :policy
end
