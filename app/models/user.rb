class User < ActiveRecord::Base
  has_one :evernote_account, dependent: :destroy
  has_one :sharing,          dependent: :destroy
  accepts_nested_attributes_for :sharing, :evernote_account

  after_create :default_associations

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
      end
    end
  end

  def connect_evernote(omniauth_response)
    logger.debug '> Connecting evernote...'
    auth_token = omniauth_response['credentials']['token']
    evernote_account.update(auth_token: auth_token)
    logger.debug '> Evernote connected!'
    SyncEvernoteAccount.enqueue(evernote_account.id)
  end

  def evernote_connected?
    evernote_account.connected?
  end

  private

  def default_associations
    Sharing.create!(user: self)
    EvernoteAccount.create!(user: self)
  end
end
