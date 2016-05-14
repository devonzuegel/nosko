class FakeEvernoteClient
  def initialize(attributes = {})
    @auth_token = attributes.fetch(:auth_token)
  end

  def notes_metadata(offset: 0, **options)
    total_n_notes = 4

    notes = []
    if (offset < total_n_notes)
      notes += [
        Evernote::EDAM::NoteStore::NoteMetadata.new(
          guid:    "blah #{Faker::Number.number(10)}",
          updated: 20.days.ago.to_i * 1000
        ), Evernote::EDAM::NoteStore::NoteMetadata.new(
          guid:    "bleh blah #{Faker::Number.number(10)}",
          updated: 0.seconds.ago.to_i * 1000
        )
      ]
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
      content:       UNPARSED_DUMMY_CONTENT,
      en_created_at: 3.days.ago,
      en_updated_at: 3.days.ago,
      guid:          Faker::Lorem.characters(30),
      notebook_guid: Faker::Lorem.characters(30),
      source_url:    nil,
      title:         "This is a test"
    }
  end

  UNPARSED_DUMMY_CONTENT = '''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
    <en-note>
      <div>blah blah blah</div>
      <div>
        <span style="-evernote-highlighted:true; background-color:#FFFFb0">
          This is a highlight
        </span>
        <p>
          This is a regular paragraph
        </p>
        <span style="-evernote-highlighted:true; background-color:#FFFFb0">
          This is a second highlight
        </span>
      </div>
    </en-note>
  '''.freeze

  PARSED_DUMMY_CONTENT = '''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
    <en-note>
      <div>blah blah blah</div>
      <div>
        <span class="highlight en-highlight">
          This is a highlight
        </span>
        <p>
          This is a regular paragraph
        </p>
        <span class="highlight en-highlight">
          This is a second highlight
        </span>
      </div>
    </en-note>
  '''.freeze
end