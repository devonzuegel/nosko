class EvernoteAccount < ActiveRecord::Base
  belongs_to :user
  has_many :extractors, class_name: 'Extractor::Article::Evernote'

  validates  :user, presence: true

  scope :connected, -> () { where.not(auth_token: nil) }

  def retrieve_each_guid
    return to_enum(__callee__) unless block_given?
    retrieve_each_note { |note| yield note.guid }
  end

  # TODO: Refactor to rely on UnpagingFacade.
  # Unpaging facade for retrieving guids of "stale" notes.
  def retrieve_each_stale_guid
    return to_enum(__callee__) unless block_given?
    retrieve_each_note do |note|
      yield note.guid if is_stale?(note)
    end
  end

  def retrieve_each_note
    return to_enum(__callee__) unless block_given?
    offset = 0
    loop do
      metadata = en_client.notes_metadata(offset: offset, n_results: 5)
      break if metadata.notes.empty?
      metadata.notes.each { |note| yield note }
      offset += metadata.notes.length
    end
  end

  def notes_metadata
    en_client.notes_metadata(n_results: 5)
  end

  def connected?
    !!auth_token
  end

  def expired?
    raise NotImplementedError
  end

  def sync
    SyncEvernoteAccount.enqueue(id)
  end

  # TODO refactor
  def is_stale?(note)
    extractor = Extractor::Article::Evernote.find_by(guid: note.guid)
    return true if extractor.nil?

    en_version_updated_at  = note.updated / 1000
    (extractor.last_accessed_at.to_i - en_version_updated_at < 0)
  end

  private

  def en_client
    @en_client ||= EvernoteClient.new(auth_token: auth_token)
  end

  def updated_interval  # Ensures conversion to utc
    last_accessed_at.nil? ? nil : last_accessed_at.utc
  end
end
