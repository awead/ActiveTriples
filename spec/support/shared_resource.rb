require 'spec_helper'

shared_context 'shared resource' do
  before do
    class DummyLicense < ActiveTriples::Resource
      property :title, :predicate => RDF::DC.title
    end

    class DummyResource < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :license, :predicate => RDF::DC.license, :class_name => DummyLicense
      property :title, :predicate => RDF::DC.title
    end
  end

  after do
    Object.send(:remove_const, "DummyResource") if Object
    Object.send(:remove_const, "DummyLicense") if Object
  end

  subject { DummyResource.new }

end
