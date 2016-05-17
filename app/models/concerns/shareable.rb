module Shareable
  extend ActiveSupport::Concern

  SHARE_BY_DEFAULT_ENUM    = { 'Only me' => 0, 'Friends'        => 1, 'Public' => 2 }
  REMINDERS_FREQUENCY_ENUM = { 'Daily'   => 0, 'Every two days' => 1, 'Weekly' => 2 }

  included do
    enum visibility: Shareable::SHARE_BY_DEFAULT_ENUM
  end
end