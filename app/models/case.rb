class Case < DashboardRecord
  # if any of these validations are changed, check the importer to ensure that it
  # isn't filtering out rows that will fail validations that no longer apply
  validates :branch_id, presence: true
  validates :case_number, presence: true
  validates :policy_number, presence: true
  validates :receipt_date, presence: true
  validates :module_number, presence: true
  validates :ann_stmt_co, presence: true

  belongs_to :policy, foreign_key: :dashboard_policy_compound_key, primary_key: :dashboard_compound_key
  has_many :features, foreign_key: :dashboard_case_compound_key, primary_key: :dashboard_compound_key, class_name: 'Feature'

  def loss_description
    [primary_loss_desc, secondary_loss_desc].compact.join(' ').humanize
  end
end
