class WildcardValidator < ActiveModel::Validator
  def validate(*); end

  # returns a settings object
  def settings
    fail 'you must override the settings method in subclasses of WildcardValidator'
  end

  def should_validate?(attr_name)
    attr_name =~ options[:wildcard] && !excluded?(attr_name) && (default? || included?(attr_name))
  end

  def default?
    settings.only.blank? && settings.except.blank?
  end

  def included?(attr_name)
    settings_only = settings.only
    settings_only.present? && settings_only.include?(attr_name.to_sym)
  end

  def excluded?(attr_name)
    settings_except = settings.except
    settings_except.present? && settings_except.include?(attr_name.to_sym)
  end
end
