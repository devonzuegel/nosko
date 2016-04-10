class EvernoteAccount < ActiveRecord::Base
  belongs_to :user
  validates  :user, presence: true

  scope :connected, -> () { where.not(auth_token: nil) }

  # TODO: Should retrieve only STALE notes; currently retrieving all.
  # TODO: Refactor to rely on UnpagingFacade.
  # Unpaging facade for retrieving guids of "stale" notes.
  def each_stale_guid
    en_client = EvernoteClient.new(auth_token: auth_token)
    offset    = 0
    loop do
      metadata = en_client.notes_metadata(offset: offset, n_results: 5)
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
    en_client.notes_metadata(offset: offset, n_results: 5)
  end

  def connected?
    !!auth_token
  end

  def expired?
    raise NotImplementedError
  end

  private

  def updated_interval  # Ensures conversion to utc
    last_accessed_at.nil? ? nil : last_accessed_at.utc
  end
end
