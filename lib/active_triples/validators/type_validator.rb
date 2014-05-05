require 'active_model'

module ActiveTriples::Validators
  class TypeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      klass = record.class.properties[attribute][:class_name]
      require 'pry'
      binding.pry
      return true if klass.nil?
      return true if klass.type.nil?
    end
  end
end
