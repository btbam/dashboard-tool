module ApplicationHelper
  def current_adjuster
    current_user.adjuster || 'Adjuster'
  end

  def current_manager
    current_user.manager || 'Keith Turner'
  end

  def current_role
    if current_user.admin?
      'admin'
    elsif current_user.manager?
      'manager'
    elsif current_user.adjuster?
      'adjuster'
    end
  end

  def can_change_managers?
    can?(:admin, :all) || can?(:read, :all)
  end

  def can_change_adjusters?
    can?(:manage, :adjusters) || can?(:admin, :all) || can?(:read, :all)
  end
end
