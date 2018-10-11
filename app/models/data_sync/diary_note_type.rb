class DataSync::DiaryNoteType < ActiveRecord::Base
  has_many :diary_notes_diary_note_types, class_name: "DataSync::DiaryNotesDiaryNoteType"
  has_many :diary_notes, through: :diary_notes_diary_note_types, class_name: "DataSync::DiaryNote"

  validates :name, uniqueness: true
  include DataSyncHelper
end
