class DataSync::RolePermission < ActiveRecord::Base
  self.table_name = "role_permissions"
  belongs_to :user, class_name: "DataSync::User"
  belongs_to :role, class_name: "DataSync::Role"
  include DataSyncHelper
end
