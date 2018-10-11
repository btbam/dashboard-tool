class FeatureDate < WritableRecord
  belongs_to :feature, primary_key: 'dashboard_compound_key', foreign_key: 'dashboard_compound_key'

  validates :dashboard_compound_key, presence: true
  # rubocop:disable Rails/Validation
  validates_uniqueness_of :dashboard_compound_key, scope: :role_name
end
