module Permalinkable
  extend ActiveSupport::Concern

  included do
    before_create :generate_permalink
    belongs_to :permalink
  end

  def generate_permalink
    return unless permalink_id.nil?
    generate_permalink!
  end

  def generate_permalink!
    self.permalink = Permalink.create!
  end

  def trash!
    permalink.update_attributes(trashed: true)
  end

  def trashed?
    permalink.trashed?
  end
end