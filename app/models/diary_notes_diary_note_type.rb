class DiaryNotesDiaryNoteType < WritableRecord
  self.sequence_name = 'NOTES_DIARY_NOTE_TYPES_SEQ'
  belongs_to :diary_note
  belongs_to :diary_note_type
end
