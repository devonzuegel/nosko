require 'rails_helper'

RSpec.describe EvernoteAccount, type: :model do
  before { evernote_client_mock }

  describe 'basic model' do
    it 'should require a user' do
      expect( build(:evernote_account, user: nil) ).to_not be_valid
    end

    it 'should test .expired?'
  end

  describe 'stale_guids mass retrieval' do
    let(:evernote_account) { create(:user).evernote_account }

    it 'should retrieve the expected number of stale guids' do
      guids = evernote_account.stale_guids
      expect(guids.length).to be EvernoteClient::Mock::METADATA_MAX_LENGTH
    end
  end

  describe 'each_stale_guid iterator' do
    let(:en_account) { create(:user).evernote_account }

    it 'should retrieve the expected number of stale guids' do
      args = en_account.stale_guids
      expect { |b| en_account.each_stale_guid(&b) }.to yield_successive_args(*args)
    end
  end
end
