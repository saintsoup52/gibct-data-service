# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V0::ApiController, type: :controller do
  controller do
    def parameter_missing
      params.require(:missing_param)
    end

    def internal_server_error
      10 / 0
    end

    def unauthorized
      raise Common::Exceptions::Unauthorized
    end
  end

  let(:keys_for_all_env) { %w(title detail code status) }
  let(:keys_for_with_meta) { keys_for_all_env + ['meta'] }

  context 'Parameter Missing' do
    subject { JSON.parse(response.body)['errors'].first }
    before(:each) do
      routes.draw { get 'parameter_missing' => 'v0/api#parameter_missing' }
      create(:version, :production)
    end

    context 'with Rails.env.test or Rails.env.development' do
      it 'renders json object with developer attributes' do
        get :parameter_missing
        expect(subject.keys).to eq(keys_for_all_env)
      end
    end

    context 'with Rails.env.production' do
      it 'renders json error with production attributes' do
        allow(Rails)
          .to(receive(:env))
          .and_return(ActiveSupport::StringInquirer.new('production'))

        get :parameter_missing
        expect(subject.keys)
          .to eq(keys_for_all_env)
      end
    end
  end

  context 'Internal Server Error' do
    subject { JSON.parse(response.body)['errors'].first }
    before(:each) do
      routes.draw { get 'internal_server_error' => 'v0/api#internal_server_error' }
      create(:version, :production)
    end

    context 'with Rails.env.test or Rails.env.development' do
      it 'renders json object with developer attributes' do
        get :internal_server_error
        expect(subject.keys).to eq(keys_for_with_meta)
      end
    end

    context 'with Rails.env.production' do
      it 'renders json error with production attributes' do
        allow(Rails)
          .to(receive(:env))
          .and_return(ActiveSupport::StringInquirer.new('production'))

        get :internal_server_error
        expect(subject.keys)
          .to eq(keys_for_all_env)
      end
    end
  end

  context 'Unauthorized' do
    subject { JSON.parse(response.body)['errors'].first }
    before(:each) do
      routes.draw { get 'unauthorized' => 'v0/api#unauthorized' }
      create(:version, :production)
    end

    context 'with Rails.env.test or Rails.env.development' do
      it 'renders json object with developer attributes' do
        get :unauthorized
        expect(subject.keys).to eq(keys_for_all_env)
      end
    end

    context 'with Rails.env.production' do
      it 'renders json error with production attributes' do
        allow(Rails)
          .to(receive(:env))
          .and_return(ActiveSupport::StringInquirer.new('production'))

        get :unauthorized
        expect(subject.keys)
          .to eq(keys_for_all_env)
        expect(response.headers['WWW-Authenticate'])
          .to eq('Token realm="Application"')
      end
    end
  end
end
