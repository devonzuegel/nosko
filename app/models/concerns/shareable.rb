module Shareable
  extend ActiveSupport::Concern

  SHARE_BY_DEFAULT_ENUM    = { 'Only me' => 0, 'Friends'        => 1, 'Public' => 2 }
  REMINDERS_FREQUENCY_ENUM = { 'Daily'   => 0, 'Every two days' => 1, 'Weekly' => 2 }

  included do
    belongs_to :user
    validates_presence_of :user

    enum visibility: SHARE_BY_DEFAULT_ENUM
    validates_inclusion_of :visibility, :in => self.visibilities.keys
    validates_presence_of  :visibility

    before_create :set_visibility_from_default
  end

  def self.share_by_default_options
    SHARE_BY_DEFAULT_ENUM.keys.map     { |k| { label: k, val: k } }
  end

  def self.reminders_frequency_options
    REMINDERS_FREQUENCY_ENUM.keys.map { |k| { label: k, val: k } }
  end

  def set_visibility_from_default
    self.visibility = user.sharing.share_by_default
  end

  def update_visibility(visibility)
    update_attributes(visibility: visibility, reviewed: true)
  end
end