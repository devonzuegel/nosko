class Finding < ActiveRecord::Base
  include Permalinkable

  KINDS = %w(Other Article Book Podcast)

  validates_presence_of :title, :kind, :url
  before_save :clean_url

  def clean_url
    self.url = self.url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
  end
end
