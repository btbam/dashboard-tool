FactoryGirl.define do
  factory :adjuster do
    adjuster_id { Faker::Internet.password(4).upcase }
    manager_id { Faker::Internet.password(4).upcase }
    name { Faker::Name.name.upcase }
    email { "#{name.split(' ').join('.').upcase}@Dashboard.COM" }
  end
end
