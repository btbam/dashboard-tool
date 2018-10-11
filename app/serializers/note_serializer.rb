class NoteSerializer < ActiveModel::Serializer
  attributes :id, :message, :note_title, :dashboard_updated_at

  has_one :author
end
