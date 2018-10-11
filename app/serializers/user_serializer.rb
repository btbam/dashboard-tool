class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :dashboard_manager_id, :email, :dashboard_adjuster_id, :is_admin, :is_manager, :is_adjuster,
             :is_executive, :adjuster, :manager, :full_name, :access_roles

  # This naming convention is for the frontend
  # rubocop:disable Style/PredicateName
  def is_admin
    object.admin?
  end

  def is_manager
    object.manager?
  end

  def is_adjuster
    object.adjuster?
  end

  def is_executive
    object.executive? || object.admin?
  end

  def adjuster
    if object.adjuster?
      adjuster = Adjuster.find_by(adjuster_id: object.dashboard_adjuster_id.to_s)
      if adjuster
        return adjuster.name.titleize
      else
        return 'Unknown Adjuster'
      end
    else
      'Adjuster'
    end
  end

  def manager
    if object.adjuster? || object.manager?
      manager = Adjuster.find_by(adjuster_id: object.dashboard_manager_id.to_s)
      if manager
        return manager.name.titleize
      else
        return 'Unknown Manager'
      end
    else
      'Manager'
    end
  end
end
