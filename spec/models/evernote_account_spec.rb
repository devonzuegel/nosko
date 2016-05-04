require 'rails_helper'

RSpec.describe EvernoteAccount, type: :model do
  before do
    Que.mode = :off
    stub_const('EvernoteClient', FakeEvernoteClient)
  end

  after do
    Que.mode = :sync
    SyncEvernoteAccount.jobs.clear
    SyncEvernoteNote.jobs.clear
  end

  describe 'basic model' do
    it 'should require a user' do
      expect( build(:evernote_account, user: nil) ).to_not be_valid
    end

    it 'should have an .authorized scope that surfaces only connected accounts' do
      2.times { create(:user)                      }
      5.times { create(:user, :evernote_connected) }

      expect(EvernoteAccount.count).to eq(7)
      expect(EvernoteAccount.connected.count).to eq 5
    end
  end

  describe '.sync' do
    require 'que/testing'

    let(:en_account) { create(:user).evernote_account }

    it 'should enqueue a SyncEvernoteAccount job' do
      expect { en_account.sync }.to change { SyncEvernoteAccount.jobs.length }.by 1
    end
  end

  describe 'guid iterator' do
    let(:en_account)    { create(:user).evernote_account  }

    it 'should retrieve all guids from Evernote' do
      en_account.retrieve_each_guid do |guid|
        expect(guid).to match /^(bleh )?blah \d{10}$/
      end
    end

    it 'should support .to_a' do
      expect(en_account.retrieve_each_guid.to_a.length).to eq 4
      en_account.retrieve_each_guid.to_a.each do |guid|
        expect(guid).to match /^(bleh )?blah \d{10}$/
      end
    end
  end

  describe 'stale guid iterator' do
    let(:en_account)    { create(:user).evernote_account  }
    let(:expected_args) { %w(blah blah) }

    before do      @all_notes = []
      en_account.retrieve_each_note do |note|
        @all_notes << note
        Extractor::Article::Evernote.create!(
          guid:             note.guid,
          evernote_account: en_account,
          last_accessed_at: 10.days.ago
        )
      end
    end

    it '2 of the 4 extractors should be stale' do
      n_stale = 0
      @all_notes.each { |note| n_stale += 1 if en_account.is_stale?(note) }
      expect(n_stale).to eq 2
    end

    it 'should support .to_a' do
      expect(en_account.retrieve_each_stale_guid.to_a.length).to eq 4
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
