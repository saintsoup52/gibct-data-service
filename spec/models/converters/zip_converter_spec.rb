# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ZipConverter do
  subject { described_class }

  it 'right justifies with leading 0s to 5 characters in length' do
    expect(subject.convert('1')).to eq('00001')
  end

  it 'returns nil if value is blank' do
    expect(subject.convert(nil)).to be_nil
    expect(subject.convert('   ')).to be_nil
  end
end
