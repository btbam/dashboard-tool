class DataSync::User < ActiveRecord::Base
  self.table_name = "users"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :token_authenticatable, :recoverable

  has_many :roles, through: :role_permissions, class_name: "DataSync::Role", foreign_key: "user_id"
  has_many :role_permissions, class_name: "DataSync::RolePermission", foreign_key: "user_id"
  has_many :diary_notes
  has_many :stars
  has_many :user_hidden_columns
  has_many :hidden_columns, through: :user_hidden_columns

  # validate_dashboard_presence except: [:dashboard_adjuster_id]
  validates :name_first, presence: true, if: :finished_registration
  validates :name_last, presence: true, if: :finished_registration
  validates :email, presence: true, uniqueness: true
  validates :dashboard_lan_id, presence: true, uniqueness: { scope: :dashboard_lan_domain }, if: :finished_registration
  validates :login, presence: true, uniqueness: true
  validate :verify_roles

  before_save :populate_auth_token

  scope :active, -> { where('current_sign_in_at > ?', Time.zone.now - 3.months) }

  include DataSyncHelper

  # If this gets more complicated, move it into its own class
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def verify_roles
    adjuster_is_blank = dashboard_adjuster_id.blank?
    manager_is_blank = dashboard_manager_id.blank?
    role_names = roles.map(&:name)
    roles_include_adjuster = role_names.include?('adjuster')
    roles_include_manager = role_names.include?('manager')

    if adjuster_is_blank && roles_include_adjuster
      errors.add(:roles, 'If the role is Adjuster, Dashboard Adjuster ID must be filled in.')
    elsif manager_is_blank && roles_include_adjuster
      errors.add(:roles, 'If the role is Adjuster, Dashboard Manager ID must be filled in.')
    elsif manager_is_blank && roles_include_manager
      errors.add(:roles, 'If the role is Manager, Dashboard Manager ID must be filled in.')
    elsif !adjuster_is_blank && roles_include_manager
      errors.add(:roles, 'If the role is Manager, Dashboard Adjuster ID must be blank.')
    elsif adjuster_is_blank && manager_is_blank && !role_names.include?('executive')
      errors.add(:roles, 'If there is not an Dashboard Adjuster or Manager ID, the Role must be Executive')
    end
  end

  def access_roles
    roles.map(&:name)
  end

  def admin?
    access_roles.include?('admin')
  end

  def manager?
    access_roles.include?('manager')
  end

  def adjuster?
    access_roles.include?('adjuster')
  end

  def executive?
    access_roles.include?('executive') || access_roles.include?('admin')
  end

  def full_name
    "#{name_first} #{name_last}".titleize
  end

  def name
    full_name
  end

  def adjuster
    return nil unless adjuster?
    Adjuster.find_by_adjuster_id(dashboard_adjuster_id)
  end

  def manager
    return nil unless adjuster?
    adjuster.manager
  end

  def dashboard_id
    if adjuster?
      dashboard_adjuster_id
    elsif manager?
      dashboard_manager_id
    end
  end

  def role_id
    if adjuster?
      Role.find_by(name: 'adjuster').id
    elsif manager?
      Role.find_by(name: 'manager').id
    end
  end

  # Checks if the Dashboard ID matches the user's ID, or their Manager's ID
  def me_or_manager?(dashboard_id)
    if self.manager?
      dashboard_manager_id == dashboard_id
    elsif self.adjuster?
      adjuster.manager.manager_id == dashboard_id
    else
      false
    end
  end

  # Checks if the Dashboard ID matche the user's ID, or if they're a manager, any of their Adjusters' IDs
  def me_or_my_adjuster?(dashboard_id)
    return false unless self.manager?
    return true if dashboard_manager_id == dashboard_id
    adjuster = Adjuster.find_by_adjuster_id(dashboard_id)
    adjuster_manager = adjuster.manager
    if adjuster && adjuster_manager && adjuster_manager.manager_id == dashboard_id
      return true
    end
    false
  end

  def dashboard_record
    Adjuster.find_by_adjuster_id(dashboard_adjuster_id)
  end

  def self.generate_random_password
    Devise.friendly_token[0..7]
  end

  def populate_auth_token
    self.authentication_token = Devise.friendly_token if authentication_token.blank?
  end
end
