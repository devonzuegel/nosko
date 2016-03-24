class Sharing < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  UPDATEABLE_ATTRIBUTES    = %i(share_by_default reminders_frequency)
  SHARE_BY_DEFAULT_OPTIONS = [{ label: 'No', val: 'false' }, { label: 'Yes', val: 'true' }]
end
