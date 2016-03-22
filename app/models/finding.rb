class Finding < ActiveRecord::Base
  include Permalinkable

  KINDS = %w(Article) # %w(Other Article Book Podcast)

  validate :restricted_kinds
  validates_each %i(title kind url) do |obj, attribute, val|
    obj.errors.add(attribute, 'may not be empty') if val.blank?
  end

  before_save :clean_url

  def clean_url
    self.url = self.url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
  end

  private

  def restricted_kinds
    unless KINDS.include? kind
      errors.add(:kind, "must be one of: #{KINDS.join(', ')}")
    end
  end
end
