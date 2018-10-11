class InviteUser
  def initialize(invited_by)
    @invited_by = invited_by
  end

  def by_email(email)
    adjuster = Adjuster.find_by(email: email)
    lan_id = adjuster.lan_id

    user = User.new(
      name_last: adjuster.name_last,
      name_first: adjuster.name_first,
      dashboard_lan_domain: 'r1-core',
      dashboard_lan_id: lan_id,
      login: lan_id,
      email: email,
      dashboard_adjuster_id: adjuster.adjuster_id
    )
    role = Role.find_by(name: 'adjuster')

    # We're making an executive user.
    if ::Ability.new(@invited_by).can?(:create, :executive_user)
      user = User.new(
        dashboard_lan_domain: 'r1-core',
        dashboard_lan_id: email,
        login: email,
        email: email
      )
      role = Role.find_by(name: 'executive')
    end

    if user
      # Removing this line for now, until we have access to an emailer
      # UserMailer.invitation_email(user, @invited_by).deliver
      user.finished_registration = false
      user.roles << role
      user.save
      user
    else
      false
    end
  end
end
