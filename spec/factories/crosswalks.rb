# frozen_string_literal: true
FactoryGirl.define do
  factory :crosswalk do
    sequence :institution do |n|
      "institution #{n}"
    end

    facility_code { generate :facility_code }
    ope { generate :ope }
    cross { generate :cross }

    trait :institution_builder do
      facility_code '1ZZZZZZZ'
      ope '99999999'
      cross '999999'
    end

    initialize_with do
      new(facility_code: facility_code, ope: ope, cross: cross)
    end
  end
end
