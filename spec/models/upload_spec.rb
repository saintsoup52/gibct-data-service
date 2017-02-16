# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Upload, type: :model do
  subject { build :upload }

  describe 'when validating' do
    it 'has a valid factory' do
      expect(subject).to be_valid
    end

    it 'requires the requesting user' do
      expect(build(:upload, user: nil)).not_to be_valid
    end

    it 'requires a filename' do
      expect(build(:upload, filename: nil)).not_to be_valid
    end

    it 'requires a csv_type' do
      expect(build(:upload, csv_type: nil)).not_to be_valid
    end

    it 'defaults to !ok' do
      expect(build(:upload, csv_type: nil).ok).to be_falsey
    end
  end
end