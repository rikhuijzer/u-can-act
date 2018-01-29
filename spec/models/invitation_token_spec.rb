# frozen_string_literal: true

require 'rails_helper'

describe InvitationToken do
  it 'should have valid default properties' do
    invitation_token = FactoryBot.build(:invitation_token)
    expect(invitation_token.valid?).to be_truthy
  end

  describe 'token' do
    it 'should not allow two invitation_tokens with the same token' do
      invitation_tokenone = FactoryBot.create(:invitation_token, token: 'myinvitation_token')
      expect(invitation_tokenone.token).to eq 'myinvitation_token'
      expect(invitation_tokenone.valid?).to be_truthy
      invitation_tokenonetwo = FactoryBot.build(:invitation_token, token: 'myinvitation_token')
      expect(invitation_tokenonetwo.valid?).to be_falsey
      expect(invitation_tokenonetwo.errors.messages).to have_key :token
      expect(invitation_tokenonetwo.errors.messages[:token]).to include('is al in gebruik')
      # If we supply a token on initialize, but that token is already in use,
      # we replace it with a different token. (So if you want to reuse a token, first delete it).
      response = FactoryBot.create(:response)
      invitation_tokenonethree = InvitationToken.new(token: 'myinvitation_token', response_id: response.id)
      expect(invitation_tokenonethree.valid?).to be_truthy
      expect(invitation_tokenonethree.token).to_not eq 'myinvitation_token'
    end
    it 'should not accept a nil token' do
      invitation_token = FactoryBot.build(:invitation_token, token: nil)
      expect(invitation_token.valid?).to be_falsey
      expect(invitation_token.errors.messages).to have_key :token
      expect(invitation_token.errors.messages[:token]).to include('moet opgegeven zijn')
    end
    it 'should not accept a blank token' do
      invitation_token = FactoryBot.build(:invitation_token, token: '')
      expect(invitation_token.valid?).to be_falsey
      expect(invitation_token.errors.messages).to have_key :token
      expect(invitation_token.errors.messages[:token]).to include('moet opgegeven zijn')
    end
  end

  describe 'response_id' do
    it 'should have one' do
      invitation_token = FactoryBot.build(:invitation_token, response_id: nil)
      expect(invitation_token.valid?).to be_falsey
      expect(invitation_token.errors.messages).to have_key :response_id
      expect(invitation_token.errors.messages[:response_id]).to include('moet opgegeven zijn')
    end
    it 'should work to retrieve a Response' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.response).to be_a(Response)
    end
    it 'should not allow for more than one token per response' do
      response = FactoryBot.create(:response)
      invitationtokenone = FactoryBot.build(:invitation_token, response: response)
      expect(invitationtokenone.valid?).to be_truthy
      invitationtokenone.save
      invitationtokentwo = FactoryBot.build(:invitation_token, response: response)
      expect(invitationtokentwo.valid?).to be_falsey
      expect(invitationtokentwo.errors.messages).to have_key :response_id
      expect(invitationtokentwo.errors.messages[:response_id]).to include('is al in gebruik')
    end
  end

  describe 'timestamps' do
    it 'should have timestamps for created objects' do
      invitation_token = FactoryBot.create(:invitation_token)
      expect(invitation_token.created_at).to be_within(1.minute).of(Time.zone.now)
      expect(invitation_token.updated_at).to be_within(1.minute).of(Time.zone.now)
    end
  end
end
