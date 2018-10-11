class UserHiddenColumn < WritableRecord
  belongs_to :user
  belongs_to :hidden_column
end
