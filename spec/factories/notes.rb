FactoryGirl.define do
  factory :note do
    dashboard_claim_id { "#{Faker::Number.number(3)}-#{Faker::Number.number(6)}" }
    dashboard_note_id { Faker::Number.number(9) }
    original_message { Faker::Lorem.sentences.join(' ') }
    message { original_message }
    processed 1
    author_id { Faker::Number.number(3).to_i }
    author_type 'Adjuster'
    dashboard_updated_at { Faker::Date.backward(365) }
    dashboard_created_at { dashboard_updated_at - rand(100).days }
    segment_id 1
    sequence(:dashboard_database_unique_id) { |n| n + 1 }
    dashboard_unique_id { "#{%w(ecso oc).sample}-#{dashboard_note_id}-#{segment_id}" }
    claims_system { [0, 1].sample }
  end
end
