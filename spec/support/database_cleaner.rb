DatabaseCleaner.strategy = :truncation, {:except => %w[diary_note_types hidden_columns model_claim roles]}

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.before(:suite) do
    model_claims = [
      { model_id: 'CCU_CLAIM_CLAIM_LIFECYCLE_001', etl_proc_date: Time.now, etl_curr_rec: 'Y',
        model_id_short: 'ALCYC01', model_name: 'CLAIM Life Cycle Model Version 1', is_numeric_model: 'Y',
        frequency: 'DAY', is_composite_model: 'N', created_date: Time.now, updated_date: Time.now, },
      { model_id: 'CCU_CLAIM_CLAIM_REMAINING_DURATION_003', etl_proc_date: Time.now, etl_curr_rec: 'Y',
        model_id_short: 'ARDUR03', model_name: 'CLAIM Remaining Duration Model Version 3', is_numeric_model: 'Y',
        frequency: 'DAY', is_composite_model: 'N', created_date: Time.now, updated_date: Time.now, },
      { model_id: 'CCU_CLAIM_CLAIM_TOUCH_EFFECT_002', etl_proc_date: Time.now, etl_curr_rec: 'Y',
        model_id_short: 'ATEFF02', model_name: 'CLAIM Touch Effect Model Version 2', is_numeric_model: 'Y',
        frequency: 'DAY', is_composite_model: 'N', created_date: Time.now, updated_date: Time.now, },
      { model_id: 'CCU_CLAIM_CLAIM_LITIGATION_002', etl_proc_date: Time.now, etl_curr_rec: 'Y',
        model_id_short: 'ALITG02', model_name: 'CLAIM Litigation Model Version 2', is_numeric_model: 'Y',
      frequency: 'DAY', is_composite_model: 'N', created_date: Time.now, updated_date: Time.now, }
    ]

    model_claims.each do |model_claim|
      ModelClaim.find_or_create_by(model_claim)
    end

    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end
end
