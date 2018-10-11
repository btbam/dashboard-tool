class DataSync::ClosedFeature < ActiveRecord::Base
  self.table_name = "closed_features"
  belongs_to :user, class_name: "DataSync::User"
  include DataSyncHelper
end
