require 'spec_helper'
require 'active_triples/validators'

describe ActiveTriples::Validators::TypeValidator do
  describe 'validating rdf types' do

    include_context 'shared resource'

    before do
      class DummyLicenseDocument < ActiveTriples::Resource
        configure :type => RDF::DC.LicenseDocument
      end

      DummyLicense.configure :type => RDF::DC.RightsStatement
      DummyResource.validates_rdf_type_of :license

      class DummyThing < ActiveTriples::Resource; end
      class DummyStandard < ActiveTriples::Resource
        configure :type => RDF::DC.Standard
      end
    end
    
    subject { DummyResource.new }
    let(:no_type) { DummyThing.new }
    let(:wrong_type) { DummyStandard.new }
    let(:right_type) { DummyLicense.new }
    let(:sub_type) { DummyLicenseDocument.new }

    context 'with no type' do
      before do
        subject.license = no_type
      end

      it 'should be invalid' do
        expect(subject).not_to be_valid
      end
    end

    context 'with incorrect type' do
      before do
        subject.license = wrong_type
      end
      
      xit 'should be invalid' do
        # fails due to property->predicate mapping
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
      before do
        subject.license = right_type
        subject.license << sub_type
      end

      it 'should be valid' do
        expect(subject).to be_valid
      end

      context 'and incorrect type' do
        before do
          subject.license = wrong_type
        end

        xit 'should be invalid' do
          # fails due to property->predicate mapping
          expect(subject).not_to be_valid
        end
      end
    end
  end  

  describe 'validating literal types' do

    let(:string) { 'blah' }
    let(:date) { Date.today }
    let(:bool) { true }

  end
end
