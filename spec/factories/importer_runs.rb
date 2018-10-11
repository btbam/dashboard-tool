FactoryGirl.define do
  factory :importer_run do
    started_at { Faker::Time.between(1.week.ago, Time.zone.now - 1.hour) }
    completed_at { started_at + 30.minutes }
    duration { 30.minutes }
    records_created { rand(100..100_000) }
    records_updated { rand(100..100_000) }
    source_model { 'OracleClaimNote' }
    destination_model { 'Note' }

    trait :with_errors do
      error_trace { Faker::Lorem.sentence }
    end

    trait :recent do
      started_at { Faker::Time.between(18.hours.ago, Time.zone.now - 2.hours) }
      completed_at { started_at + 30.minutes }
    end

    trait :not_recent do
      started_at { Faker::Time.between(1.week.ago, 36.hours.ago) }
      completed_at { started_at + 30.minutes }
    end

    trait :unproductive do
      records_created 0
      records_updated 0
    end
  end
end
