require 'rails_helper'

RSpec.describe EvernoteAccount, type: :model do
  describe 'basic model' do
    it 'should require a user' do
      expect( build(:evernote_account, user: nil) ).to_not be_valid
    end
    it 'should test .expired?'
  end

  describe 'each_stale_guid iterator' do
    let(:evernote_account) { create(:user).evernote_account }

    before do
      notes = 10.times.map { Evernote::EDAM::NoteStore::NoteMetadata.new(guid: Faker::Lorem.characters(10)) }
      notes_metadata = Evernote::EDAM::NoteStore::NotesMetadataList.new(
        notes:      notes,
        startIndex: 0,
        # totalNotes: Faker::Number.between(notes.length, 10*notes.length)
      )
      EvernoteClient.any_instance.stub(notes_metadata: notes_metadata, ping_evernote: nil)
      # @en_client = EvernoteClient.new(auth_token: Faker::Lorem.characters(10))
    end


    it 'should retrieve the expected number of stale guids' do
      ap evernote_account.notes_metadata
      evernote_account.each_stale_guid { |guid| ap guid }
      # raise NotImplementedError
    end
  end
end
