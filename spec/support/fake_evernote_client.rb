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
end