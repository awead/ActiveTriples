require 'spec_helper'
require 'active_triples/validators'

describe ActiveTriples::Validators::VocabValidator do
  before do
    class DummyResource < ActiveTriples::Resource
      property :see_also, :predicate => RDF::RDFS.seeAlso
      validate :license
    end
  end

  after do
    Object.send(:remove_const, "DummyResource")
  end
  
  context 'with non-vocab term' do
    it 'should be invalid' do
      expect(subject).not_to be_valid
    end
  end

  context 'with vocab term' do
    it 'should be valid' do
      expect(subject).to be_valid
    end
  end
end
