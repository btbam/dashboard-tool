class ModelClaim < DashboardRecord
  self.table_name = 'model_claim'

  def self.duration_attention_flag_value
    @duration_attention_flag_value ||=
      find_by_model_id('CCU_CLAIM_CLAIM_REMAINING_DURATION_003').attention_flag_value
  end

  def self.touch_attention_flag_value
    @touch_attention_flag_value ||=
      find_by_model_id('CCU_CLAIM_CLAIM_TOUCH_EFFECT_002').attention_flag_value
  end
end
