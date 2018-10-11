class DiaryNoteDetailSerializer < DiaryNoteSerializer
  attributes :object_type

  def object_type
    object.class.name
  end
end
