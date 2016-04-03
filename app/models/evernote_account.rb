class EvernoteAccount < ActiveRecord::Base
  belongs_to :user

  validates  :user, presence: true

  scope :authorized, -> () { where.not(auth_token: nil) }

  def self.sync_notes_for_all_users
    # Shuffle order of users in which sync occurs so that every user gets average service.
    authorized.shuffle.each do |authorized_account| authorized_account.sync_notes end
  end

  def expired?
    raise NotImplementedError
  end

  def retrieve_notes
    en_client = EvernoteClient.new(auth_token: auth_token)
    en_client.notes(updated_interval: updated_interval)
  end

  def sync_notes
    raise Error, "EvernoteAccount ##{id} is not connected." if !connected?

    puts "Syncing Evernote notes for EvernoteAccount ##{id}..."

    retrieve_notes.each do |note_attrs|
      # EvernoteExtraction.update_or_create!(note_attrs.merge(user: user))
    end

    puts "Done syncing notes for EvernoteAccount ##{id}.\n"
  end

  def connected?
    !!auth_token
  end

  private

  def updated_interval  # Ensures conversion to utc
    last_accessed_at.nil? ? nil : last_accessed_at.utc
  end
end
