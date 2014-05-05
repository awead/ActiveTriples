require 'spec_helper'
require 'active_triples/validators'

describe ActiveTriples::Validators::TypeValidator do
  before do
    class DummyLicense < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/License')
      property :title, :predicate => RDF::DC.title
    end

    class DummyThing < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/Thing')
    end
    
    class DummyResource < ActiveTriples::Resource
      property :license, :predicate => RDF::DC.license, :class_name => DummyLicense
      property :title, :predicate => RDF::DC.title

      validate :license
    end
  end

  after do
    Object.send(:remove_const, "DummyResource")
    Object.send(:remove_const, "DummyLicense")
    Object.send(:remove_const, "DummyThing")
  end

  subject { DummyResource.new }
  context 'with incorrect type' do
    it 'should be invalid' do
      subject.license = DummyThing.new
      expect(subject).not_to be_valid
    end
  end

  context 'with incorrect literal instead of typed node' do
    it 'should be invalid' do
      subject.license = 'Comet in Moominland'
      expect(subject).not_to be_valid
    end
  end

  context 'with correct type' do
    it 'should be valid' do
      subject.license = subject.license = DummyLicense.new
      expect(subject).to be_valid
    end
    context 'and incorrect type' do
      it 'should be invalid' do
        subject.license = DummyThing.new
        expect(subject).not_to be_valid
      end
    end
  end
end
