class Article < Finding
  validates :content, presence: true, blank: false

  REQUIRED_FIELDS = superclass::REQUIRED_FIELDS + %i(content)
  OPTIONAL_FIELDS = superclass::OPTIONAL_FIELDS
  FIELDS          = REQUIRED_FIELDS + OPTIONAL_FIELDS
end