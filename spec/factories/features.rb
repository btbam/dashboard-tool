FactoryGirl.define do
  factory :feature do
    branch_id { Faker::Number.number(3) }
    case_id { Faker::Number.number(6) }
    feature_id { Faker::Number.number(1) }
    feature_created { Faker::Date.backward(365) }
    current_adjuster { Faker::Internet.password(4).upcase }
    claim_status 'O'
    sequence(:dashboard_database_unique_id) { |n| n }
    dashboard_compound_key { "#{branch_id}-#{case_id}-#{feature_id}" }
    claim_id { "#{branch_id}-#{case_id}" }
    dashboard_case_compound_key { "#{branch_id}-#{case_id}" }
   
    factory :feature_with_notes do
      transient do
        notes_count 5
      end

      after(:create) do |feature, evaluator|
        create_list(:note, evaluator.notes_count, feature: feature)
      end
    end
  end
end
