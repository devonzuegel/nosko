class Finding < ActiveRecord::Base
  include Permalinkable
  self.abstract_class = true

  validates :title, presence: true, blank: false
  validates :url,   presence: true, blank: false

  before_save :clean_url

  REQUIRED_FIELDS = %i(title url)
  OPTIONAL_FIELDS = %i()

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  private

  def clean_url
    self.url = self.url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
  end
end