module ActiveTriples
  module Validators
    autoload :TypeValidator,   'active_triples/validators/type_validator'
    autoload :DomainValidator, 'active_triples/validators/domain_validator'
    autoload :VocabValidator,  'active_triples/validators/vocab_validator'
  end
end
