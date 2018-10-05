# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OneTimeResponseController, type: :controller do
  let(:protocol) { FactoryBot.create(:protocol, :with_measurements) }
  let(:one_time_response) { FactoryBot.create(:one_time_response, protocol: protocol) }
  let!(:team) { FactoryBot.create(:team, :with_roles, name: Rails.application.config.settings.default_team_name) }

  describe 'SHOW /' do
    it 'should head 404 if the provided token is not found' do
      get :show, params: { q: '123' }
      expect(response.status).to eq 404
    end

    it 'should subscribe to a protocol when called with the correct token' do
      pre_count = ProtocolSubscription.count
      get :show, params: { q: one_time_response.token }
      post_count = ProtocolSubscription.count
      expect(pre_count + 1).to eq post_count
    end

    it 'should create the person when called' do
      pre_count = Person.count
      get :show, params: { q: one_time_response.token }
      post_count = Person.count
      expect(pre_count + 1).to eq post_count
    end

    it 'should subscribe the person to the created protocol subscription' do
      expect(Person.count).to eq 0
      get :show, params: { q: one_time_response.token }
      expect(Person.count).to eq 1
      expect(Person.last.protocol_subscriptions.length).to eq 1
    end

    it 'should redirect to token authentication controller' do
      get :show, params: { q: one_time_response.token }
      expect(response.status).to eq 302
      expect(response.location).to start_with 'http://test.host?q='
    end

    it 'should schedule the correct responses' do
      protocol.measurements.first.update_attributes!(open_from_offset: 0)
      get :show, params: { q: one_time_response.token }
      expect(response.status).to eq 302
      expect(Person.last.my_open_responses.length).to eq 1
    end
  end
end