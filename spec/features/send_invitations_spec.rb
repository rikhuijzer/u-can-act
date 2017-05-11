# frozen_string_literal: true

require 'rails_helper'

describe 'sending invitations' do
  let!(:some_response) do
    FactoryGirl.create(:response, open_from: 1.hour.ago)
  end
  let!(:another_response) do
    FactoryGirl.create(:response, open_from: 90.minutes.ago)
  end
  let!(:third_response) do
    FactoryGirl.create(:response, open_from: 45.minutes.ago)
  end

  let(:responses) { [some_response, another_response, third_response] }

  before(:each) do
    # Clear the messagebird list, as we will have an sms for the newly created profile.
    MessageBirdAdapter.deliveries.clear
  end

  describe 'without delayed_jobs' do
    before(:each) do
      Delayed::Worker.delay_jobs = false
    end

    after(:each) do
      Delayed::Worker.delay_jobs = true
    end

    it 'should send sms messages for open responses' do
      SendInvitations.run
      expect(MessageBirdAdapter.deliveries.size).to eq responses.length

      MessageBirdAdapter.deliveries.each_with_index do |msg, index|
        expect(msg[:to]).to eq(responses[index].protocol_subscription.person.mobile_phone)
        expect(msg[:body]).to_not be_blank
        expect(msg[:body]).to include('http')
        expect(msg[:body]).to include("/?q=#{responses[index].invitation_token.token}")
        expect(msg[:reference]).to eq "vsv-#{responses[index].id}"
      end
    end

    describe 'without active protocol_subscriptions' do
      it 'should not do anything when the protocol_subscriptions are not active' do
        responses.each do |response|
          response.protocol_subscription.update_attributes!(state: ProtocolSubscription::CANCELED_STATE)
        end
        MessageBirdAdapter.deliveries.clear
        SendInvitations.run
        expect(MessageBirdAdapter.deliveries).to be_empty
      end
    end
  end

  describe 'with delayed jobs' do
    before :each do
      expect(Delayed::Worker.delay_jobs).to be_truthy
    end

    it 'should not schedule the sms if the delayed jobs are enabled' do
      SendInvitations.run
      expect(MessageBirdAdapter.deliveries.size).to eq 0
      expect(Delayed::Job.all.length).to eq responses.length
    end
  end
end
