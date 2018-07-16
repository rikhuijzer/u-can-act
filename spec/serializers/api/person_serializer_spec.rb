# frozen_string_literal: true

require 'rails_helper'

describe Api::PersonSerializer do
  let!(:person) { FactoryBot.create(:person, :with_iban, email: 'test@test.com') }

  subject(:json) { described_class.new(person).as_json.with_indifferent_access }

  describe 'renders the correct json' do
    it 'should contain the correct variables' do
      expect(json).to_not be_nil
      expect(json.keys).to match_array %w[first_name last_name gender iban email mobile_phone]
    end

    it 'should contain the correct value for the first_name' do
      expect(person.first_name).to_not be_blank
      expect(json['first_name']).to eq person.first_name
    end

    it 'should contain the correct value for the last_name' do
      expect(person.last_name).to_not be_blank
      expect(json['last_name']).to eq person.last_name
    end

    it 'should contain the correct value for the mobile_phone' do
      expect(person.mobile_phone).to_not be_blank
      expect(json['mobile_phone']).to eq person.mobile_phone
    end

    it 'should contain the correct value for the iban' do
      expect(person.iban).to_not be_blank
      expect(json['iban']).to eq person.iban
    end

    it 'should contain the correct value for the email' do
      expect(person.email).to_not be_blank
      expect(json['email']).to eq person.email
    end

    it 'should contain the correct value for the gender' do
      expect(person.gender).to_not be_blank
      expect(json['gender']).to eq person.gender
    end
  end
end