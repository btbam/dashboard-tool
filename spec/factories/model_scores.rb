FactoryGirl.define do
  factory :model_score do
    attention_trigger 'N'
    branch_cd { Faker::Number.number(3) }
    case_no { Faker::Number.number(6) }
    claim_id { Faker::Number.number(3) + '-' + Faker::Number.number(6)}
    etl_curr_rec 'Y'
    etl_orig_rec 'N'
    etl_proc_date { Faker::Date.backward(7) }
    etl_row_id 3
    feature_id { Faker::Number.between(1, 13) }
    model_id 'CCU_CLAIM_CLAIM_TOUCH_EFFECT_002'
    oc_feature_no '-.'
    score_delta_orig { Faker::Number.between(0, 7) }
    score_delta_week 0
    score_effective_at { Faker::Date.backward(7) }
    score_id { Faker::Number::number(6) }
    symbol { Faker::Number.between(0, 13) }
    value_numeric { Faker::Number.between(-999999, -1) }
    value_numeric_adj_rank { Faker::Number.between(1, 4200) }

    trait :duration do
      model_id 'CCU_CLAIM_CLAIM_REMAINING_DURATION_003'
      etl_row_id 2
    end

    trait :lifecycle do
      model_id 'CCU_CLAIM_CLAIM_LIFECYCLE_001'
      etl_row_id 1
    end

    trait :litigation do
      model_id 'CCU_CLAIM_CLAIM_LITIGATION_002'
      etl_row_id 4
    end

    trait :touch do
      model_id 'CCU_CLAIM_CLAIM_TOUCH_EFFECT_002'
      etl_row_id 3
    end
  end
end
