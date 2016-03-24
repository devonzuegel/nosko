class Article < Finding
  validates :content, presence: true, blank: false

  REQUIRED_FIELDS = superclass::REQUIRED_FIELDS + %i(content)
  OPTIONAL_FIELDS = superclass::OPTIONAL_FIELDS

  def trashed?
    permalink.trashed?
  end
end