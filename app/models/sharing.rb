class Sharing < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  UPDATEABLE_ATTRIBUTES = %i(share_by_default reminders_frequency)

  enum share_by_default:    { 'Only me' => 0,  'Friends'        => 1,  'Public' => 2 }
  enum reminders_frequency: { 'Daily'   => 0,  'Every two days' => 1,  'Weekly' => 2 }

  def self.share_by_default_options
    self.share_by_defaults.keys
  end

  def self.reminders_frequency_options
    self.reminders_frequencies.keys
  end
end
