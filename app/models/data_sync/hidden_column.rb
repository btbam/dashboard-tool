class DataSync::HiddenColumn < ActiveRecord::Base
  has_many :user_hidden_columns, class_name: "DataSync::UserHiddenColumn"
  has_many :users, through: :user_hidden_columns, class_name: "DataSync::User"

  validates :column_name, uniqueness: true
  include DataSyncHelper
end
