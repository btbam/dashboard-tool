class Adjuster < DashboardRecord
  # if any of these validations are changed, check the importer to ensure that it
  # isn't filtering out rows that will fail validations that no longer apply
  validates :adjuster_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validate_dashboard_presence except: [:dashboard_claim_unique_id, :dashboard_claim_manager_unique_id]
  validate_dashboard_uniqueness except: [:dashboard_claim_manager_unique_id]

  has_many :notes, as: :author
  has_many :features, foreign_key: :current_adjuster, primary_key: :adjuster_id, class_name: 'Feature'
  has_one :manager, foreign_key: :adjuster_id, primary_key: :manager_id, class_name: 'Adjuster'
  has_many :subordinates, foreign_key: :manager_id, primary_key: :adjuster_id, class_name: 'Adjuster'

  scope :named_like, ->(name) { where(arel_table[:name].matches("%#{name.upcase}%")).order(arel_table[:name]) }
  scope :with_open_features, lambda {
                               distinct(:id)
                                 .joins("left outer join features on (
                                    adjusters.adjuster_id = features.current_adjuster and
                                    features.claim_status in ('O', 'S') and features.feature_created is not null
                                  )")
                                 .joins('left outer join managers on adjusters.adjuster_id = managers.manager_id')
                                 .where('managers.id is not null or features.id is not null')
                             }

  def name_first
    name.split[0]
  end

  def name_last
    surname = name.split[1..-1].join(' ')
    surname unless surname.blank?
  end

  def self.all_subordinates(manager_id, ids = [])
    if !manager_id || manager_id.empty?
      ids
    else
      new_ids = Adjuster.where(manager_id: manager_id).pluck(:adjuster_id)
      new_ids -= ids
      all_subordinates(new_ids, (ids + new_ids).uniq)
    end
  end
end
