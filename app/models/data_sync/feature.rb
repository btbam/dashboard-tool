class DataSync::Feature < ActiveRecord::Base
  enum claims_system: { ecso: 0, one_claim: 1 }

  # if any of these validations are changed, check the importer to ensure that it
  # isn't filtering out rows that will fail validations that no longer apply
  # validates :feature_created, presence: true
  validates :branch_id, presence: true
  validates :case_id, presence: true
  validates :current_adjuster, presence: true
  validates :claim_status, presence: true, inclusion: { in: %w(V U M C B N O S) }
  validates :dashboard_compound_key, presence: true, uniqueness: true
  validates :claim_id, presence: true, uniqueness: { scope: [:claims_system, :feature_id] }
  # validate_dashboard_presence except: [:dashboard_type_id, :dashboard_unique_feature_id]

  belongs_to :adjuster, foreign_key: :current_adjuster, class_name: 'Adjuster', primary_key: :adjuster_id
  belongs_to :case, primary_key: :dashboard_compound_key, foreign_key: :dashboard_case_compound_key, class_name: 'Case'
  has_one :policy, through: :case
  has_one :closed_feature, primary_key: :dashboard_compound_key, foreign_key: :dashboard_compound_key, class_name: "DataSync::ClosedFeature"
  has_many :diary_notes, -> { displayable.order(updated_at: :desc) },
           primary_key: :dashboard_compound_key, foreign_key: :dashboard_compound_key, class_name: "DataSync::DiaryNote"
  has_one :last_diary_note, -> { displayable.order(updated_at: :desc).limit(1) },
          primary_key: :dashboard_compound_key, foreign_key: :dashboard_compound_key, class_name: "DataSync::DiaryNote"
  has_one :feature_date, primary_key: :dashboard_compound_key, foreign_key: :dashboard_compound_key, class_name: "DataSync::FeatureDate"
  has_many :stars, primary_key: :dashboard_compound_key
  has_many :notes, -> { displayable.order(dashboard_updated_at: :desc) },
           foreign_key: :dashboard_claim_id,
           primary_key: :claim_id,
           class_name: 'Note'
  has_one :last_adjuster_note, -> { displayable.where(author_type: 'Adjuster').order(dashboard_updated_at: :desc).limit(1) },
          foreign_key: :dashboard_claim_id,
          primary_key: :claim_id,
          class_name: 'Note'
  has_one :last_manager_note, -> { displayable.where(author_type: 'Manager').order(dashboard_updated_at: :desc).limit(1) },
          foreign_key: :dashboard_claim_id,
          primary_key: :claim_id,
          class_name: 'Note'
  has_one :last_adjuster_summary, -> { where(author_type: 'Adjuster').order(updated_at: :desc).limit(1) },
          foreign_key: :dashboard_compound_key,
          primary_key: :dashboard_compound_key,
          class_name: 'ActivitySummary'
  has_one :last_manager_summary, -> { where(author_type: 'Manager').order(updated_at: :desc).limit(1) },
          foreign_key: :dashboard_compound_key,
          primary_key: :dashboard_compound_key,
          class_name: 'ActivitySummary'
  has_one :last_adjuster_feature_date, -> { where(role_name: 'adjuster').order(updated_at: :desc).limit(1) },
          foreign_key: :dashboard_compound_key,
          primary_key: :dashboard_compound_key,
          class_name: "DataSync::FeatureDate"
  has_one :last_manager_feature_date, -> { where(role_name: ['manager', nil]).order(updated_at: :desc).limit(1) },
          foreign_key: :dashboard_compound_key,
          primary_key: :dashboard_compound_key,
          class_name: "DataSync::FeatureDate"
  has_many :financials, ->(o) { where(feature_id: o.feature_id, branch_id: o.branch_id, case_id: o.case_id) },
           foreign_key: :case_id,
           primary_key: :case_id
  has_many :dashboard_model_values, foreign_key: :dashboard_feature_id, primary_key: :dashboard_compound_key
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :dashboard_models
  has_many :model_scores, (lambda do
    where(model_id: %w(CCU_CLAIM_CLAIM_LIFECYCLE_001
                       CCU_CLAIM_CLAIM_REMAINING_DURATION_003
                       CCU_CLAIM_CLAIM_TOUCH_EFFECT_002
                       CCU_CLAIM_CLAIM_LITIGATION_002
                    )
         )
  end), primary_key: :claim_id, foreign_key: :claim_id, class_name: 'ModelScore'

  scope :open, -> { where(claim_status: %w(O S)) }
  scope :closed, -> { where.not(claim_status: %w(O S)) }
  scope :with_created_date, -> { where.not(feature_created: nil) }
  scope :claims_system, (lambda do |claims_system|
    where(claims_system: claims_systems[claims_system.try(:to_sym)] || claims_system)
  end)
  scope :claim_id, ->(claim_id) { where(claim_id: claim_id) }
  scope :current_adjuster, ->(adjuster) { where(current_adjuster: adjuster.try(:adjuster_id) || adjuster) }
  scope :for_api, -> { select(:id).distinct.eager_load([:adjuster, { case: :policy }]) }
  scope :for_warming, lambda {
    distinct(:id).includes([:adjuster, { case: :policy }], :feature_date, { last_diary_note: :user },
                           :closed_feature, :model_scores
                          )
  }

  include DataSyncHelper

  def total_outstanding
    [indemnity_outstanding, medical_outstanding, legal_outstanding].reduce(0) { |a, e| a + e.to_f }
  end

  def total_paid
    [indemnity_paid, medical_paid, legal_paid].reduce(0) { |a, e| a + e.to_f }
  end

  def last_note_datetime
    notes.first.try(:dashboard_updated_at)
  end

  def datetime_humanize(datetime)
    datetime.strftime('%-m/%-d/%y')
  end

  def feature_created_humanize
    datetime_humanize(feature_created)
  end

  def claimant_name_humanize
    claimant_name.try(:titleize)
  end

  def notification_scores
    @notification_scores ||=
      model_scores.select { |m| m.model_id == 'CCU_CLAIM_CLAIM_LIFECYCLE_001' && m.feature_id = feature_id }
    @notification_scores.each(&:create_notification)
  end

  def duration_scores
    @duration_scores ||=
      model_scores.select { |m| m.model_id == 'CCU_CLAIM_CLAIM_REMAINING_DURATION_003' && m.feature_id = feature_id }
  end

  def touch_scores
    @touch_scores ||=
      model_scores.select { |m| m.model_id == 'CCU_CLAIM_CLAIM_TOUCH_EFFECT_002' && m.feature_id = feature_id }
  end

  def litigation_scores
    @litigation_scores ||=
      model_scores.select { |m| m.model_id == 'CCU_CLAIM_CLAIM_LITIGATION_002' && m.feature_id = feature_id }
  end

  def duration_score
    @duration_score ||= duration_scores.sort { |a, b| a.score_effective_at <=> b.score_effective_at }.last
  end

  def touch_score
    @touch_score ||= touch_scores.sort { |a, b| a.score_effective_at <=> b.score_effective_at }.last
  end

  def litigation_score
    @litigation_score ||= litigation_scores.sort { |a, b| a.score_effective_at <=> b.score_effective_at }.last
    @litigation_score.try(:value_character)
  end

  def flags
    touch = { type: 'touch' }
    duration = { type: 'duration' }

    return_flags = []
    return_flags << touch if touch_flag
    return_flags << duration if duration_flag

    notification_scores

    return_flags
  end

  def touch_flag
    if touch_score
      value_numeric = touch_score.value_numeric.to_f
      attention_flag_value = ModelClaim.touch_attention_flag_value.to_f

      return true if value_numeric < attention_flag_value
    end
    false
  end

  def duration_flag
    if duration_score
      score_delta_week = duration_score.score_delta_week.to_f
      score_delta_original = duration_score.score_delta_orig.to_f
      attention_flag_value = ModelClaim.duration_attention_flag_value.to_f

      if (score_delta_week > attention_flag_value) || (score_delta_original > attention_flag_value)
        return true
      end
    end
    false
  end
end
