class FakeEvernoteClient
  def initialize(attributes = {})
    @auth_token = attributes.fetch(:auth_token)
  end

  def notes_metadata(offset:, **options)
    total_n_notes = 5

    notes = []
    if (offset < total_n_notes)
      notes << Evernote::EDAM::NoteStore::NoteMetadata.new(guid: 'blahblah')
    end

    Evernote::EDAM::NoteStore::NotesMetadataList.new(
      totalNotes: total_n_notes,
      notes:      notes
    )
  end

  def find_note_by_guid(guid)
    {
      active:        true,
      author:        "devonzuegel_1",
      content:       "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n<en-note><div>blah blah blah</div></en-note>",
      en_created_at: 3.days.ago,
      en_updated_at: 3.days.ago,
      guid:          Faker::Lorem.characters(30),
      notebook_guid: Faker::Lorem.characters(30),
      source_url:    nil,
      title:         "This is a test"
    }
  end
end