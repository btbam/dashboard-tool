class RolePermission < WritableRecord
  belongs_to :user
  belongs_to :role
end
