module Shareable
  extend ActiveSupport::Concern

  SHARE_BY_DEFAULT_ENUM    = { 'Only me' => 0, 'Friends'        => 1, 'Public' => 2 }
  REMINDERS_FREQUENCY_ENUM = { 'Daily'   => 0, 'Every two days' => 1, 'Weekly' => 2 }

  def self.share_by_default_options
    SHARE_BY_DEFAULT_ENUM.keys.map     { |k| { label: k, val: k } }
  end

  def self.reminders_frequency_options
    REMINDERS_FREQUENCY_ENUM.keys.map { |k| { label: k, val: k } }
  end

  included do
    enum visibility: SHARE_BY_DEFAULT_ENUM
  end
end