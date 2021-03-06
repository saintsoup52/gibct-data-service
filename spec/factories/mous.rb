# frozen_string_literal: true
FactoryGirl.define do
  factory :mou do
    ope { generate :ope }
    status 'probation - dod'

    trait :by_dod do
      status 'probation - dod'
    end

    trait :by_title_iv do
      status 'title iv non-compliant'
    end

    trait :institution_builder do
      ope '99999999'
    end

    initialize_with do
      new(ope: ope, status: status)
    end
  end
end
