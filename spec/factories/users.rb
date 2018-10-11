FactoryGirl.define do
  factory :user do
    name_first { Faker::Name.first_name }
    name_last { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    dashboard_lan_id { Faker::Internet.user_name(name_first[0] + name_last) }
    login { dashboard_lan_id }
    dashboard_adjuster_id { Faker::Internet.password(4).upcase }
    dashboard_manager_id { Faker::Internet.password(4).upcase }
    roles { [Role.find_by_name('adjuster')] }
  end
end
