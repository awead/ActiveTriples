require 'active_model'

module ActiveTriples::Validators
  class VocabValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      require 'pry'
      binding.pry
    end
  end
end
