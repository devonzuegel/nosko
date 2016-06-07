module Lockable
  extend ActiveSupport::Concern

  # REQUIRED_FIELDS = %i(locked)

  included do
  end

  def locked?
    locked
  end

  def unlocked?
    !locked?
  end

  def lock!
    update(locked: true)
  end

  def unlock!
    update(locked: false)
  end
end