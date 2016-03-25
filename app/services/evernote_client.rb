# TODO refactor me!
# TODO add many tests

class EvernoteClient
  include EvernoteParsable

  OFFSET           = 0
  N_RESULTS        = 100
  ORDER            = :updated
  ASCENDING        = false
  UPDATED_INTERVAL = 1.day.ago

  def initialize(attributes = {})
    @auth_token = attributes.fetch(:auth_token)
    @client = EvernoteOAuth::Client.new(token: @auth_token, sandbox: !Rails.env.production?)
    ping_evernote
  end

  def notebooks
    note_store.listNotebooks(@auth_token).map { |n| format_notebook(n) }
  end

  def notebook_counts(order: ORDER, ascending: ASCENDING, updated_interval: UPDATED_INTERVAL)
    note_store.findNoteCounts(@auth_token, filter(order: order, ascending: ascending, updated_interval: updated_interval), false)
  end

  def en_user
    user_store.getUser(@auth_token)
  end

  def notes_metadata(n_results: N_RESULTS, order: ORDER, ascending: ASCENDING, updated_interval: UPDATED_INTERVAL)
    custom_filter = filter(order: order, ascending: ascending, updated_interval: updated_interval)
    note_store.findNotesMetadata(custom_filter, OFFSET, n_results, notes_metadata_result_spec)
  end

  def notes(n_results: N_RESULTS, order: ORDER, ascending: ASCENDING, updated_interval: UPDATED_INTERVAL)
    options    = { n_results: n_results, order: order, ascending: ascending, updated_interval: updated_interval }
    note_guids = notes_metadata(options).notes.map(&:guid)
    notes      = note_guids.map { |guid| find_note_by_guid(guid) }
  end

  def find_note_by_guid(guid)
    note = note_store.getNote(@auth_token, guid, true, true, true, true)
    format_note(note)
  end

  private

  def user_store
    @client.user_store
  end

  def note_store
    @client.note_store
  end

  def ping_evernote
    note_store
  rescue Evernote::EDAM::Error::EDAMUserException => e
    raise Evernote::EDAM::Error::EDAMUserException, 'Invalid authentication token.'
  end

  def filter(order: order, ascending: ASCENDING, updated_interval: UPDATED_INTERVAL)
    Evernote::EDAM::NoteStore::NoteFilter.new(
      order:     sort_order_value(order),
      ascending: ascending,
      words:     date_search_format(updated_interval)
    )
  end

  def date_search_format(date)
    (date.blank?) ? '' : "updated:#{date.utc.strftime('%Y%m%dT%H%M%S')}"
  end

  def notes_metadata_result_spec
    Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new(
      includeTitle:         true,
      includeContentLength: true,
      includeCreated:       true,
      includeUpdated:       true,
      includeDeleted:       true,
      includeNotebookGuid:  true,
      includeAttributes:    true,
      includeTagGuids:      true
    )
  end

  def sort_order_value_map
    Evernote::EDAM::Type::NoteSortOrder::VALUE_MAP.map { |k, v| [v.downcase, k] }.to_h
  end

  # More information at `dev.evernote.com/doc/reference/Types.html#Enum_NoteSortOrder`.
  def sort_order_value(order = ORDER)
    value_map = sort_order_value_map
    order     = order.to_s.downcase # Treats up/downcase symbols/strings equally (e.g. :title ~ :TITLE ~ 'title' ~ 'TITLE')
    unless value_map.include? order
      msg = "#{order} is not a valid Evernote sort order. Please choose from " \
            "#{value_map.keys.to_sentence(last_word_connector:', or ')}"
      raise Exception, msg
    end
    value_map[order]
  end
end