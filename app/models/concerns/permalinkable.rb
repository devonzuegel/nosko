module Permalinkable
  extend ActiveSupport::Concern

  included do
    belongs_to :permalink
    validates_presence_of :permalink

    after_initialize :generate_permalink
    scope :active,  -> { all.select { |p| !p.trashed? } }
    scope :trashed, -> { all.select { |p|  p.trashed? } }
  end


  def generate_permalink
    return unless permalink.nil?
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