class FeatureWithDiarySerializer < FeatureSerializer
  has_one :diary_note

  delegate :priority_flag, to: :object

  delegate :flag_reason, to: :object

  delegate :recommended_action, to: :object
end
