class DataSync::Role < ActiveRecord::Base
  self.table_name = "roles"
  has_many :users, :through => :role_permissions
  has_many :role_permissions

  validates :name, uniqueness: true
  include DataSyncHelper
end
