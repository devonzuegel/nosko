class Sharing < ActiveRecord::Base
  has_one :user
  UPDATEABLE_ATTRIBUTES = %i(share_by_default reminders_frequency)
end
