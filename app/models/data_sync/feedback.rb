class DataSync::Feedback < ActiveRecord::Base
  self.table_name = "feedbacks"
  belongs_to :user, class_name: "DataSync::User"
  belongs_to :feature, primary_key: 'dashboard_compound_key'
  include DataSyncHelper
end
