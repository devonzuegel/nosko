class Finding < ActiveRecord::Base
  include Permalinkable

  KINDS = %w(Article) # %w(Other Article Book Podcast)

  validates_each %i(title kind url) do |obj, attribute, val|
    obj.errors.add(attribute, 'may not be empty') if val.blank?
  end

  before_save :clean_url

  private

  def clean_url
    self.url = self.url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
  end
end