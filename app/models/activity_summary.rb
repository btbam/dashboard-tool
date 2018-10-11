class ActivitySummary < ActiveRecord::Base
  belongs_to :feature, primary_key: :dashboard_compound_key, foreign_key: :dashboard_compound_key
  belongs_to :author, foreign_key: :author_id, primary_key: :id, class_name: 'Adjuster'
end
