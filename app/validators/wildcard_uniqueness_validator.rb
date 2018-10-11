class WildcardUniquenessValidator < WildcardValidator
  def validate(record)
    @record = record
    record.attribute_names.each do |attr_name|
      read_attribute = record.read_attribute(attr_name)
      if should_validate?(attr_name) && read_attribute
        validator = ActiveRecord::Validations::UniquenessValidator.new(attributes: attr_name, class: record.class)
        validator.validate_each(record, attr_name, read_attribute)
      end
    end
  end

  def settings
    @record.class.instance_variable_get(:@dashboard_uniqueness_validations)
  end
end
