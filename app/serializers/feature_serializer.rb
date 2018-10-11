class FeatureSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :adjuster_name, :claimant_name, :dashboard_compound_key,
             :feature_id, :updated_at, :indemnity_outstanding, :medical_outstanding,
             :legal_outstanding, :total_outstanding, :force_closed, :last_adjuster_note, :diary_notes,
             :state, :last_manager_note, :litigation, :total_paid, :flags, :last_adjuster_summary,
             :last_manager_summary, :last_adjuster_feature_date, :last_manager_feature_date,
             :feature_created

  has_one :case
  has_one :feature_date
  has_one :last_adjuster_feature_date
  has_one :last_adjuster_note, serializer: NoteSerializer
  has_one :last_manager_feature_date
  has_one :last_manager_note, serializer: NoteSerializer
  has_many :diary_notes

  def adjuster_name
    adjuster = object.adjuster
    adjuster.name.humanize if adjuster
  end

  def claimant_name
    object.claimant_name_humanize
  end

  def diary_notes
    [object.last_diary_note]
  end

  def feature_date
    FeatureDate.new(due: nil,
                    dashboard_compound_key: object.dashboard_compound_key,
                    created_at: Time.zone.now,
                    role_name: nil)
  end

  def feature_id
    object.feature_id.to_i
  end

  def force_closed
    object.closed_feature ? true : false
  end

  def last_adjuster_summary
    last_adjuster_summary = object.last_adjuster_summary
    if last_adjuster_summary && last_adjuster_summary.diary_scheduled_date
      last_adjuster_summary.diary_scheduled_date += 12.hours
    end
    last_adjuster_summary
  end

  def last_manager_summary
    last_manager_summary = object.last_manager_summary
    if last_manager_summary && last_manager_summary.diary_scheduled_date
      last_manager_summary.diary_scheduled_date += 12.hours
    end
    last_manager_summary
  end

  def litigation
    object.litigation_score
  end
end
