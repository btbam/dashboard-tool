class DataSync::DiaryNote < ActiveRecord::Base
  belongs_to :user, class_name: "DataSync::User"
  belongs_to :feature, primary_key: 'dashboard_compound_key', foreign_key: 'dashboard_compound_key'
  has_many :diary_notes_diary_note_types, class_name: "DataSync::DiaryNotesDiaryNoteType"
  has_many :diary_note_types, through: :diary_notes_diary_note_types, class_name: "DataSync::DiaryNoteType"

  validates :user_id, presence: true
  validates :dashboard_compound_key, presence: true

  scope :displayable, -> { where(deleted: false) }
  scope :by_dashboard_compound_key, ->(dashboard_compound_key) { where(dashboard_compound_key: dashboard_compound_key) }
  include DataSyncHelper
end
