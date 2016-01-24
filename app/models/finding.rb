class Finding < ActiveRecord::Base
  KINDS = %w(Other Article Book Podcast)

  before_save :clean_url

  def clean_url
    self.url = self.url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
  end
end
