class Article < ActiveRecord::Base
  belongs_to :finding
  validates_presence_of :finding
  validates :content, presence: true, blank: false

  def initialize(attrs = {})
    raise "Attribute hash must not be empty" if attrs.blank?
    finding_attrs = { title: attrs.delete(:title), url: attrs.delete(:url), kind: 'Article' }
    super(attrs.merge(finding: Finding.create!(finding_attrs)))
    ap self
  end

  def trashed?
    finding.trashed?
  end
end
