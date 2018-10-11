class DiaryNoteType < WritableRecord
  has_many :diary_notes_diary_note_types
  has_many :diary_notes, through: :diary_notes_diary_note_types

  validates :name, uniqueness: true
end
