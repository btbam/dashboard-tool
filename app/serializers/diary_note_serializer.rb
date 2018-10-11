class DiaryNoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :author, :diary, :diary_note_types

  def diary_note_types
    object.diary_note_types.pluck(:name)
  end

  def author
    user = object.user
    if user
      { 'name' => user.full_name, 'email' => user.email }
    else
      { 'name' => 'N/A', 'email' => 'N/A' }
    end
  end

  def feature_id
    object.dashboard_compound_key
  end
end
