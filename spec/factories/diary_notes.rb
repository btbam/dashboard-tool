FactoryGirl.define do
  factory :diary_note do
    dashboard_compound_key 1
    user_id 1
    diary ''
    created_at '2015-05-15 20:34:11'
    updated_at '2015-05-15 20:34:11'
  end
end
