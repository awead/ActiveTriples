require 'active_model'
require 'rdf/reasoner'
require 'rdf/reasoner/rdfs'

module ActiveTriples::Validators
  class DomainValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, values)
      predicate = record.class.properties[attribute][:predicate]
      require 'pry'
      binding.pry if record.type.first != RDF::DC.BibliographicResource
      record.errors.add(attribute, "Resource is of invalid type for domain restrictions on #{predicate.to_s}).") unless RDF::Vocabulary.find_term(predicate).domain_compatible?(record.rdf_subject, record)
    end
  end
end

module ActiveModel::Validations::HelperMethods
  def validates_domain_of(*attr_names)
    validates_with ActiveTriples::Validators::DomainValidator, :attributes => attr_names
  end
end
