class Feedback < WritableRecord
  belongs_to :user
  belongs_to :feature, primary_key: 'dashboard_compound_key'
end
