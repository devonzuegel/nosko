class FacebookAccount < ActiveRecord::Base
  belongs_to :user
  validates  :user, presence: true

  scope :connected, -> () { where.not(auth_token: nil) }

  def connected?
    !!auth_token
  end

  def connect(omniauth_response)
    Rails.logger.debug '> Connecting Facebook...'
    puts 'BEFORE'.black
    ap self
    update_attributes(
      auth_token:   omniauth_response['credentials']['token'],
      email:        omniauth_response['info']['email'],
      expires_at:   omniauth_response['credentials']['expires_at'],
      fb_id:        omniauth_response['extra']['raw_info']['id'],
      image:        omniauth_response['info']['image'],
      name:         omniauth_response['info']['name'],
      uid:          omniauth_response['uid'],
    )
    puts 'AFTER'.black
    ap self
    Rails.logger.debug '> Facebook connected!'
  end

  def expired?
    raise NotImplementedError
  end
end
