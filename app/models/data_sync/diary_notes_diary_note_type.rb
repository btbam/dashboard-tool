class DataSync::DiaryNotesDiaryNoteType < ActiveRecord::Base
  self.sequence_name = 'NOTES_DIARY_NOTE_TYPES_SEQ'
  belongs_to :diary_note, class_name: "DataSync::DiaryNote"
  belongs_to :diary_note_type, class_name: "DataSync::DiaryNoteType"
  include DataSyncHelper
end
