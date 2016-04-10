class EvernoteAccount < ActiveRecord::Base
  belongs_to :user
  validates  :user, presence: true
  scope :authorized, -> () { where.not(auth_token: nil) }

  # Retrieves chunks of notes from the Evernote API. Surfaces an iterator on
  # each individual note that hides that fact that it retrieves N at a time.
  def each_stale_guid
    en_client = EvernoteClient.new(auth_token: auth_token)
    offset    = 0
    loop do
      metadata = en_client.notes_metadata(offset: offset, n_results: N_RESULTS)
      break if metadata.notes.empty?
      metadata.notes.each { |note| yield note.guid }
      offset += metadata.notes.length
    end
  end

  def stale_guids
    guids = []
    each_stale_guid { |g| guids << g }
    guids
  end

  def notes_metadata
    en_client = EvernoteClient.new(auth_token: auth_token)
    en_client.notes_metadata(n_results: 10).notes
  end

  def connected?
    !!auth_token
  end

  def expired?
    raise NotImplementedError
  end

  private

  N_RESULTS = 100

  def updated_interval  # Ensures conversion to utc
    last_accessed_at.nil? ? nil : last_accessed_at.utc
  end
end
