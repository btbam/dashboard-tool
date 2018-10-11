class DiaryNote < WritableRecord
  belongs_to :user
  belongs_to :feature, primary_key: 'dashboard_compound_key', foreign_key: 'dashboard_compound_key'
  has_many :diary_notes_diary_note_types
  has_many :diary_note_types, through: :diary_notes_diary_note_types

  validates :user_id, presence: true
  validates :dashboard_compound_key, presence: true

  scope :displayable, -> { where(deleted: false) }
  scope :by_dashboard_compound_key, ->(dashboard_compound_key) { where(dashboard_compound_key: dashboard_compound_key) }
end
