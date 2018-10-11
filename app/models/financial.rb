class Financial < DashboardRecord
  belongs_to :case, foreign_key: :case_id, primary_key: :case_number
  belongs_to :feature, ->(obj) { where(case_id: obj.case_id, feature_id: obj.feature_id, branch_id: obj.branch_id) },
             class_name: 'Feature',
             foreign_key: :case_id,
             primary_key: :case_id,
             inverse_of: :financials
end
