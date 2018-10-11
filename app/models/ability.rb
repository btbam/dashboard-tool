class Ability
  include CanCan::Ability

  # This is the way cancan is intended to be used
  # rubocop:disable Metrics/AbcSize
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    # Users can manage their own diary notes and stars
    can :manage, DiaryNote, user_id: user.id
    can :manage, Star, user_id: user.id

    # TODO: Filter to only features belonging to user
    can :manage, FeatureDate

    if user.access_roles.include?('admin')
      can :manage, :all
      can :access, :rails_admin
      can :dashboard
    elsif user.access_roles.include?('executive')
      can :read, :all
      can :create, :adjuster_user
      can :create, :manager_user
      can :create, :executive_user
    elsif user.access_roles.include?('manager')
      can :access, :rails_admin
      can :dashboard
      can :manage, User, dashboard_manager_id: user.dashboard_manager_id
      cannot :manage, User, id: user.id
      can :create, :adjuster_user
      can :manage, Feature
      can :read, :claims_manager_api
      can :read, :claims_adjuster_api
      can :read, Role, name: 'adjuster'
      can :read, Adjuster
      can :manage, RolePermission, user_id: User.where(dashboard_manager_id: user.dashboard_manager_id).pluck(:id)
    elsif user.access_roles.include?('adjuster')
      can :manage, Feature, current_adjuster: user.dashboard_adjuster_id
      can :read, :claims_adjuster_api
    end
  end
end
