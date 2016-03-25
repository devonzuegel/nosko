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
    en_client        = EvernoteClient.new(auth_token: auth_token)
    en_client.notes(n_results: 1, updated_interval: updated_interval).map { |h| h[:content]='REMOVED FOR NOW'; h }
  end

  def sync_notes
    puts "Syncing Evernote notes for EvernoteAccount ##{id}..."

    while true
      retrieved = retrieve_notes
      break if retrieved.empty?
      retrieved.each { |note_attrs| EvernoteNote.update_or_create!(note_attrs) }
      break  # TODO remove me
    end
    puts "Done syncing notes for EvernoteAccount ##{id}.\n"
  end

  private

  def updated_interval  # Ensures conversion to utc
    last_updated.nil? ? nil : last_updated.utc
  end
end
