module EvernoteClient::Mock
  def evernote_client_mock
    notes_metadata_stub
    notes_metadata_end_stub
    ping_evernote_stub
  end

  private

  METADATA_CHUNK_SIZE = 10
  METADATA_MAX_LENGTH = 3 * METADATA_CHUNK_SIZE

  def notes_metadata_stub
    notes          = METADATA_CHUNK_SIZE.times.map { meta_datum_stub }
    options        = { notes: notes, totalNotes: METADATA_MAX_LENGTH }
    notes_metadata = Evernote::EDAM::NoteStore::NotesMetadataList.new(options)
    EvernoteClient.any_instance.stub(:notes_metadata) { notes_metadata }
  end

  def notes_metadata_end_stub
    options        = { notes: [], totalNotes: METADATA_MAX_LENGTH }
    notes_metadata = Evernote::EDAM::NoteStore::NotesMetadataList.new(options)
    EvernoteClient.any_instance.stub(:notes_metadata)
                  .with(hash_including(offset: METADATA_MAX_LENGTH)) { notes_metadata }
  end

  def ping_evernote_stub
    EvernoteClient.any_instance.stub(:ping_evernote) { nil }
  end

  def meta_datum_stub
    Evernote::EDAM::NoteStore::NoteMetadata.new(guid: Faker::Lorem.characters(10))
  end
end
