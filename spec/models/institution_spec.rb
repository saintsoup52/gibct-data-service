# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Institution, type: :model do
  describe 'when validating' do
    subject { create :institution }

    it 'has a valid factory' do
      expect(subject).to be_valid
    end

    it 'requires a valid and unique facility_code' do
      expect(build(:institution, facility_code: nil)).not_to be_valid

      duplicate_facility = build :institution, facility_code: subject.facility_code
      expect(duplicate_facility).not_to be_valid
      expect(duplicate_facility.errors.messages).to eq(facility_code: ['has already been taken'])
    end

    it 'requires a version' do
      expect(build(:institution, version: nil)).not_to be_valid
    end

    it 'requires an institution (name)' do
      expect(build(:institution, institution: nil)).not_to be_valid
    end

    it 'requires a country' do
      expect(build(:institution, country: nil)).not_to be_valid
    end

    it 'requires a valid institution_type_name' do
      expect(build(:institution, institution_type_name: nil)).not_to be_valid
      expect(build(:institution, institution_type_name: 'blah-blah')).not_to be_valid
    end
  end

  describe 'scorecard_link' do
    let(:url) { 'https://collegescorecard.ed.gov/school/?1234567-myschool' }

    it 'returns a url' do
      expect(build(:institution, cross: '1234567', institution: 'myschool').scorecard_link).to eq(url)
    end

    it 'returns nil if the institution is not a school' do
      expect(build(:institution, institution_type_name: 'ojt')).not_to be_nil
    end
  end

  describe 'website_link' do
    let(:url) { 'http://myschool.com' }

    it 'returns a url' do
      expect(build(:institution, insturl: 'myschool.com').website_link).to eq(url)
    end

    it 'returns nil if insturl is blank' do
      expect(build(:institution, insturl: '').website_link).to be_nil
    end
  end

  describe 'vet_website_link' do
    let(:url) { 'http://myschool.com' }

    it 'returns a url' do
      expect(build(:institution, vet_tuition_policy_url: 'myschool.com').vet_website_link).to eq(url)
    end

    it 'returns nil if vet_tuition_policy_url is blank' do
      expect(build(:institution, vet_tuition_policy_url: '').vet_website_link).to be_nil
    end
  end

  describe 'complaints' do
    let(:complaint_fac_code) { build :institution, complaints_facility_code: 1 }

    it 'returns a hash of complaint counts' do
      complaints = complaint_fac_code.complaints

      expect(complaints['facility_code']).to eq(1)
    end
  end

  describe 'locale_type' do
    it 'maps locale numbers to descriptions' do
      {
        'city' => [11, 12, 13], 'suburban' => [21, 22, 23], 'town' => [31, 32, 33], 'rural' => [41, 42, 43]
      }.each_pair do |description, locales|
        locales.each do |locale|
          expect(build(:institution, locale: locale).locale_type).to eq(description)
        end
      end
    end

    it 'is nil for non-mapped values' do
      expect(build(:institution, locale: 1).locale_type).to be_nil
    end
  end

  describe 'highest_degree' do
    it 'maps pred_degree_awarded to a common value' do
      expect(build(:institution, pred_degree_awarded: 0).highest_degree).to be_nil
      expect(build(:institution, pred_degree_awarded: 1).highest_degree).to eq('Certificate')
      expect(build(:institution, pred_degree_awarded: 2).highest_degree).to eq(2)
      expect(build(:institution, pred_degree_awarded: 3).highest_degree).to eq(4)
      expect(build(:institution, pred_degree_awarded: 4).highest_degree).to eq(4)
    end

    it 'maps va_highest_degree_offered to a common value' do
      expect(build(:institution, va_highest_degree_offered: 0).highest_degree).to be_nil
      expect(build(:institution, va_highest_degree_offered: 'ncd').highest_degree).to eq('Certificate')
      expect(build(:institution, va_highest_degree_offered: '2-year').highest_degree).to eq(2)
      expect(build(:institution, va_highest_degree_offered: '4-year').highest_degree).to eq(4)
    end

    it 'prefers pred_degree_awarded over va_highest_degree_offered' do
      expect(build(:institution, pred_degree_awarded: 2, va_highest_degree_offered: '4-year').highest_degree).to eq(2)
    end
  end

  describe 'school?' do
    it 'returns true if an institution is not ojt' do
      expect(build(:institution, institution_type_name: 'ojt')).not_to be_school
      expect(build(:institution, institution_type_name: 'private')).to be_school
    end
  end

  describe 'class methods and scopes' do
    context 'version' do
      it 'should retrieve institutions by a specific version number' do
        i = create_list :institution, 2, version: 1
        j = create_list :institution, 2, version: 2

        expect(Institution.version(i.first.version)).to eq(i.to_a)
        expect(Institution.version(j.first.version)).to eq(j.to_a)
      end

      it 'returns blank if a nil or non-existent version number is supplied' do
        create :institution

        expect(Institution.version(-1)).to eq([])
        expect(Institution.version(nil)).to eq([])
      end
    end

    context 'filter scope' do
      it 'should raise an error if no arguments are provided' do
        expect { described_class.filter }.to raise_error(ArgumentError)
      end

      it 'should filter on field existing' do
        expect(described_class.filter('institution', 'true').to_sql)
          .to include("WHERE \"institutions\".\"institution\" = 't'")
      end

      it 'should filter on field not existing' do
        expect(described_class.filter('institution', 'false').to_sql)
          .to include("WHERE (\"institutions\".\"institution\" != 't')")
      end
    end

    context 'search scope' do
      it 'should return nil if no search term is provided' do
        expect(described_class.search(name: nil)).to be_empty
      end

      it 'should search when attribute is provided' do
        expect(described_class.search(name: 'chicago').to_sql)
          .to include(
            "WHERE (lower(facility_code) = ('---\n- :name\n- chicago\n')",
            "OR lower(institution) LIKE ('%{:name=>\"chicago\"}%')",
            "OR lower(city) LIKE ('%{:name=>\"chicago\"}%'))"
          )
      end
    end
  end
end