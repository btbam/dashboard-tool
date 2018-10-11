class Policy < DashboardRecord
  # if any of these validations are changed, check the importer to ensure that it
  # isn't filtering out rows that will fail validations that no longer apply
  validates :policy_number, presence: true, uniqueness: { scope: [:module_number, :ann_stmt_co] }
  validates :module_number, presence: true, uniqueness: { scope: [:policy_number, :ann_stmt_co] }
  validates :ann_stmt_co, presence: true, uniqueness: { scope: [:policy_number, :module_number] }
  validates :issuing_company, presence: true
  validates :producer_number, presence: true

  has_many :cases, foreign_key: :dashboard_policy_compound_key, primary_key: :dashboard_compound_key
  has_many :features, through: :cases

  def insured_name_humanize
    insured_name.gsub(/^"/, '').gsub(/"$/, '').titleize if insured_name
  end
end
