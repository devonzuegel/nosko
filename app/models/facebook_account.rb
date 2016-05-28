class FacebookAccount < ActiveRecord::Base
  belongs_to :user
  validates  :user, presence: true

  scope :connected, -> () { where.not(auth_token: nil) }

  def connected?
    !!auth_token
  end

  def expired?
    raise NotImplementedError
  end
end
