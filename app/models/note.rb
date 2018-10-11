class Note < DashboardRecord
  include ActionView::Helpers::TextHelper

  enum claims_system: { ecso: 0, one_claim: 1 }

  # if any of these validations are changed, check the importer to ensure that it
  # isn't filtering out rows that will fail validations that no longer apply
  validates :original_message, presence: true
  validates :dashboard_note_id, uniqueness: { scope: [:claims_system, :segment_id] }
  validates :claims_system, presence: true
  validates :segment_id, presence: true, uniqueness: { scope: [:claims_system, :dashboard_note_id] }
  validate_dashboard_presence except: [:dashboard_feature_id, :dashboard_user_name, :dashboard_author_id]
  validate_dashboard_uniqueness except: [:dashboard_database_unique_id]

  belongs_to :feature, foreign_key: :dashboard_claim_id, primary_key: :claim_id
  belongs_to :author, foreign_key: :author_id, primary_key: :id, class_name: 'Adjuster'

  scope :displayable, -> { processed.where(segment_id: 1) }
  scope :processed, -> { where(processed: 1) }
  scope :unprocessed, -> { where(Note.arel_table[:processed].eq(0).or(Note.arel_table[:processed].eq(nil))) }
  scope :ecso, -> { where(claims_system: 0) }
  scope :claim, -> { where(claims_system: 1) }

  def human_message
    simple_format(message)
  end
end
