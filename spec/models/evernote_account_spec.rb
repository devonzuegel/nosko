require 'rails_helper'

RSpec.describe EvernoteAccount, type: :model do
  describe 'basic model' do
    it 'should require a user'
    it 'should test .expired?'
  end

  describe 'each_stale_guid iterator' do
    before do
      EvernoteClient.any_instance.stub(notes_metadata: 'BLAH BLAH BLAH', ping_evernote: nil)
    end

    it 'should retrieve the expected number of stale guids' do
      en_client = EvernoteClient.new(auth_token: Faker::Lorem.characters(10))
      en_client.notes_metadata
      raise NotImplementedError
    end
  end
end
