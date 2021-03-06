# frozen_string_literal: true
FactoryGirl.define do
  factory :institution do
    sequence(:id) { |n| n }
    facility_code { generate :facility_code }
    cross { generate :cross }
    sequence(:institution) { |n| "institution #{n}" }
    sequence(:country) { |n| "country #{n}" }
    sequence(:insturl) { |n| "www.school.edu/#{n}" }
    institution_type_name 'PRIVATE'
    version 1

    trait :in_nyc do
      city 'NEW YORK'
      state 'NY'
      country 'USA'
    end

    trait :in_new_rochelle do
      city 'NEW ROCHELLE'
      state 'NY'
      country 'USA'
    end

    trait :in_chicago do
      city 'CHICAGO'
      state 'IL'
      country 'USA'
    end

    trait :uchicago do
      institution 'UNIVERSITY OF CHICAGO - NOT IN CHICAGO'
      city 'SOME OTHER CITY'
      state 'IL'
      country 'USA'
    end

    trait :start_like_harv do
      sequence(:institution) { |n| ["HARV#{n}", "HARV #{n}"].sample }
      city 'BOSTON'
      state 'MA'
      country 'USA'
    end

    trait :contains_harv do
      sequence(:institution) { |n| ["HASHARV#{n}", "HAS HARV #{n}"].sample }
      city 'BOSTON'
      state 'MA'
      country 'USA'
    end

    trait :ca_employer do
      institution 'ACME INC'
      city 'LOS ANGELES'
      state 'CA'
      country 'USA'
      institution_type_name 'OJT'
    end

    trait :institution_builder do
      facility_code '1ZZZZZZZ'
      ope '99999999'
      ope6 '99999'
      cross '999999'
      version 1
    end
  end
end
