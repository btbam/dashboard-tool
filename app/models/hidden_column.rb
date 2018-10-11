class HiddenColumn < WritableRecord
  has_many :user_hidden_columns
  has_many :users, through: :user_hidden_columns

  validates :column_name, uniqueness: true
end
