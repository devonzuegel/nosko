class Friendship < ActiveRecord::Base
  belongs_to :friender, class_name: 'User'
  belongs_to :friendee, class_name: 'User'

  validates_presence_of :friender_id, :friendee_id

  scope :confirmed,   -> { where(confirmed: true)  }
  scope :unconfirmed, -> { where(confirmed: false) }

  def confirmed?
    confirmed
  end

  def confirm!
    update_attributes(confirmed: true)
  end
end
