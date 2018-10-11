require 'ostruct'

class WritableDashboardRecord < WritableRecord
  self.abstract_class = true

  include ActiveModel::Validations

  validates_with WildcardPresenceValidator, wildcard: /^dashboard_/i
  validates_with WildcardUniquenessValidator, wildcard: /^dashboard_.*unique/i

  class << self
    def inherited(subclass)
      subclass.instance_variable_set(:@dashboard_presence_validations, OpenStruct.new)
      subclass.instance_variable_set(:@dashboard_uniqueness_validations, OpenStruct.new)
      super
    end

    def validate_dashboard_uniqueness(_colname = nil, except: [], only: [], allow_nil: nil)
      @dashboard_uniqueness_validations.except = [*except].map(&:to_sym)
      @dashboard_uniqueness_validations.only = [*only].map(&:to_sym)
      @dashboard_uniqueness_validations.allow_nil = allow_nil
      exceptions = @dashboard_uniqueness_validations.except.present?
      onlys = @dashboard_uniqueness_validations.only.present?
      return if exceptions && !onlys
      return if !exceptions && onlys
      fail 'you cannot use both "except" and "only" with #validate_dashboard_uniqueness'
    end

    def validate_dashboard_presence(except: [], only: [])
      @dashboard_presence_validations.except = [*except].map(&:to_sym)
      @dashboard_presence_validations.only = [*only].map(&:to_sym)
      exceptions = @dashboard_presence_validations.except.present?
      onlys = @dashboard_presence_validations.only.present?
      return if exceptions && !onlys
      return if !exceptions && onlys
      fail 'you cannot use both "except" and "only" with #validate_dashboard_presence'
    end
  end
end
