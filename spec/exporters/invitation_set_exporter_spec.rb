# frozen_string_literal: true

require 'rails_helper'

describe InvitationSetExporter do
  it_should_behave_like 'an object_exporter object'

  context 'without invitation sets' do
    it 'works without invitation sets' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  context 'with invitation sets' do
    before do
      student = FactoryBot.create(:student)
      FactoryBot.create(:invitation_set, person: student)
      mentor = FactoryBot.create(:mentor)
      FactoryBot.create(:invitation_set, person: mentor)
      # create a response that should be filtered out
      person = FactoryBot.create(:student, :with_test_phone_number)
      invitation_set = FactoryBot.create(:invitation_set, person: person)
      FactoryBot.create(:response, invitation_set: invitation_set)
    end

    it 'works with invitation sets' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 3
      # bubblebabble format for first field (person_id)
      expect(export.last.split(';', -1).second).to match(/\A"([a-z]{5}\-){4}[a-z]{5}"\z/)
      expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
    end
  end
end
