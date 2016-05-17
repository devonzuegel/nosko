class Sharing < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  UPDATEABLE_ATTRIBUTES = %i(share_by_default reminders_frequency)

  enum share_by_default:    Shareable::SHARE_BY_DEFAULT_ENUM
  enum reminders_frequency: Shareable::REMINDERS_FREQUENCY_ENUM
end
