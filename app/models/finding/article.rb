module Finding
  class Article < ActiveRecord::Base
    include Permalinkable

    validates :user,       presence: true, blank: false
    validates :title,      presence: true, blank: false
    validates :source_url, presence: true, blank: false

    belongs_to :user,          dependent: :destroy
    has_one    :evernote_note, dependent: :destroy
    validates  :content, presence: true, blank: false

    REQUIRED_FIELDS = %i(title source_url user content)
    OPTIONAL_FIELDS = %i()
    FIELDS          = REQUIRED_FIELDS + OPTIONAL_FIELDS

    before_save :clean_url, :save_user

    private

    def save_user
      user.save!
    end

    def clean_url
      self.source_url = self.source_url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
    end
  end
end

