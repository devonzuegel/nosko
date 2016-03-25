class Finding < ActiveRecord::Base
  include Permalinkable
  self.abstract_class = true

  validates :user,       presence: true, blank: false
  validates :title,      presence: true, blank: false
  validates :source_url, presence: true, blank: false

  before_save :clean_url

  REQUIRED_FIELDS = %i(title source_url)
  OPTIONAL_FIELDS = %i()

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  private

  def clean_url
    self.source_url = self.source_url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
  end
end