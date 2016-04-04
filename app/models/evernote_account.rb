class EvernoteAccount < ActiveRecord::Base
  belongs_to :user
  validates  :user, presence: true
  scope :authorized, -> () { where.not(auth_token: nil) }

  def each_stale_guid
    en_client = EvernoteClient.new(auth_token: auth_token)
    offset    = 0
    loop do
      metadata = en_client.notes_metadata(offset: offset, n_results: 100)
      break if metadata.notes.empty?
      metadata.notes.each do |note|
        yield note.guid
      end
      offset += metadata.notes.length
    end
  end

  def notes_metadata
    en_client = EvernoteClient.new(auth_token: auth_token)
    en_client.notes_metadata(n_results: 10).notes.map &:guid
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
