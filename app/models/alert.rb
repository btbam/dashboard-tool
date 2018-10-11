class Alert < ActiveRecord::Base
  validates :text, presence: true
  validates :level, presence: true
  validates :expires, presence: true

  LEVELS = [:success, :info, :warning, :danger]
  enum level: LEVELS

  scope :not_expired, -> { where(arel_table[:expires].gt(Time.zone.now)) }

  def self.displayable
    not_expired
  end

  # Rails Admin support
  def level_enum
    LEVELS
  end
end
