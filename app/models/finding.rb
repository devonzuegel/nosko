class Finding < ActiveRecord::Base
  include Permalinkable

  KINDS = %w(Other Article Book Podcast)

  before_save :clean_url, :generate_permalink

  def clean_url
    self.url = self.url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
  end
end
