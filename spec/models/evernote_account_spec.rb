require 'rails_helper'

RSpec.describe EvernoteAccount, type: :model do
  before { evernote_client_mock }

  describe 'basic model' do
    it 'should require a user' do
      expect( build(:evernote_account, user: nil) ).to_not be_valid
    end

    it 'should have an .authorized scope that surfaces only connected accounts' do
      n_unconnected = Faker::Number.between(1,10)
      n_connected   = Faker::Number.between(1,10)

      n_unconnected.times { create(:user)                      }
      n_connected.times   { create(:user, :evernote_connected) }

      expect(EvernoteAccount.count).to eq(n_unconnected + n_connected)
      expect(EvernoteAccount.connected.count).to eq n_connected
    end
  end

  describe 'each_stale_guid iterator' do
    let(:en_account) { create(:user).evernote_account }

    it 'should retrieve the expected number of stale guids' do
      args = en_account.stale_guids
      expect { |b| en_account.each_stale_guid(&b) }.to yield_successive_args(*args)
    end
  end

  describe 'stale_guids mass retrieval' do
    let(:evernote_account) { create(:user).evernote_account }

    it 'should retrieve the expected number of stale guids' do
      guids = evernote_account.stale_guids
      expect(guids.length).to be EvernoteClient::Mock::METADATA_MAX_LENGTH
    end
  end

  describe '.connected?' do
    it 'should return false on an unconnected account' do
      expect(create(:evernote_account).connected?).to eq false
    end

    it 'should return true on a connected account' do
      expect(create(:evernote_account, :connected).connected?).to eq true
    end
  end

  describe 'expired?' do
    it 'should ...'
  end
end
