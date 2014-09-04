require 'spec_helper'

describe ActiveTriples::Validators::DomainValidator do

  before do
    class LocalVocab < RDF::StrictVocabulary("http://example.org/my/")
      term :Book, subClassOf: "dc:BibliographicResource".freeze
    end

    class MyResource < ActiveTriples::Resource
      validates_domain_of :citation
      property :citation, :predicate => RDF::DC.bibliographicCitation
    end
  end

  after do
    Object.send(:remove_const, "MyResource")
    Object.send(:remove_const, "LocalVocab")
  end

  subject { MyResource.new }

  context 'with no type on resource' do
    it 'uses inferred type' do
      expect(subject).to be_valid
    end
  end

  context 'with valid type on resource' do
    before do
      MyResource.configure :type => RDF::DC.BibliographicResource
    end

    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'with valid subclass type on resource' do
    before do
      MyResource.configure :type => LocalVocab.Book
    end

    xit 'is valid' do
      # this ought to work, but fails!
      # something going on in rdf-reasoner?
      expect(subject).to be_valid
    end
  end

  context 'with invalid type on resource' do
    before do
      MyResource.configure :type => RDF::DC.Agent
    end

    it 'is invalid' do
      expect(subject).not_to be_valid
    end

    it 'has errors' do
      subject.valid?
      expect(subject.errors.messages[:citation].count).to eq 1
    end
  end

  

end
