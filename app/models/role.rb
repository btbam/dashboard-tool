class Role < WritableRecord
  has_many :users, through: :role_permissions
  has_many :role_permissions

  validates :name, uniqueness: true
end
