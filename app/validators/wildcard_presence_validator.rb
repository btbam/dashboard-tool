class WildcardPresenceValidator < WildcardValidator
  def validate(record)
    @record = record
    record.attribute_names.each do |attr_name|
      if should_validate?(attr_name) && record.read_attribute(attr_name).blank?
        record.errors.add attr_name.to_sym, "can't be blank"
      end
    end
  end

  def settings
    @record.class.instance_variable_get(:@dashboard_presence_validations)
  end
end
