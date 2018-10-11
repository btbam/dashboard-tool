class DataSync::UserHiddenColumn < ActiveRecord::Base
  belongs_to :user, class_name: "DataSync::User"
  belongs_to :hidden_column, class_name: "DataSync::HiddenColumn"
  include DataSyncHelper
end
