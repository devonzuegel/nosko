class Article < Finding
  belongs_to :user,          dependent: :destroy
  has_one    :evernote_note, dependent: :destroy
  validates  :content, presence: true, blank: false

  REQUIRED_FIELDS = superclass::REQUIRED_FIELDS + %i(content)
  OPTIONAL_FIELDS = superclass::OPTIONAL_FIELDS
  FIELDS          = REQUIRED_FIELDS + OPTIONAL_FIELDS

  before_save :save_user

  private

  def save_user
    user.save!
  end
end