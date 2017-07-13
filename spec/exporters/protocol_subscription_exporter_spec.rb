# frozen_string_literal: true

require 'rails_helper'

describe ProtocolSubscriptionExporter do
  context 'without protocol subscriptions' do
    it 'works without protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  context 'with protocol subscriptions' do
    before do
      FactoryGirl.create(:student, :with_protocol_subscriptions)
      FactoryGirl.create(:mentor, :with_protocol_subscriptions)
      # create a response that should be filtered out
      person = FactoryGirl.create(:student, mobile_phone: '0611055958')
      protocol_subscription = FactoryGirl.create(:protocol_subscription, person: person)
      FactoryGirl.create(:response, protocol_subscription: protocol_subscription)
    end
    it 'works with protocol subscriptions' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 3
      # bubblebabble format for first field (person_id)
      expect(export.last.split(';', -1).second).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';', -1)[-2]).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end
  end
end