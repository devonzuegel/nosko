class Article < Finding
  validates :content, presence: true, blank: false

  def trashed?
    finding.trashed?
  end

  def kind
    'Article'
  end
end