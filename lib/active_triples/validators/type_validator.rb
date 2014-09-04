require 'active_model'
require 'rdf/reasoner'
require 'rdf/reasoner/rdfs'

module ActiveTriples::Validators
  class TypeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, values)
      klass = record.class.properties[attribute][:class_name]
      return true if klass.nil?
      return true if klass.type.nil?
      term = RDF::Vocabulary.find_term(klass.type)
      values.each do |value|
        record.errors.add(attribute, :rdf_type) unless check_type(term, value)
      end
    end

    private 

      def check_type(term, value)
        return false unless value.respond_to? :type
        valid_types = term.entail(:subClass).map(&:to_s)
        value.type.each do |t|
          return true if valid_types.include? t.to_s
        end
        false
      end

  end
end

module ActiveModel::Validations::HelperMethods
  def validates_rdf_type_of(*attr_names)
    validates_with ActiveTriples::Validators::TypeValidator, :attributes => attr_names
  end
end

