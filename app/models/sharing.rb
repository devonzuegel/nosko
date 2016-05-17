class Sharing < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  UPDATEABLE_ATTRIBUTES = %i(share_by_default reminders_frequency)

  enum share_by_default:    Shareable::SHARE_BY_DEFAULT_ENUM
  enum reminders_frequency: Shareable::REMINDERS_FREQUENCY_ENUM

  def self.share_by_default_options
    self.share_by_defaults.keys.map     { |k| { label: k, val: k } }
  end

  def self.reminders_frequency_options
    self.reminders_frequencies.keys.map { |k| { label: k, val: k } }
  end
end
