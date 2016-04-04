class User < ActiveRecord::Base
  has_one :evernote_account, dependent: :destroy
  has_one :sharing,          dependent: :destroy
  accepts_nested_attributes_for :sharing, :evernote_account

  after_create :add_sharing, :add_empty_evernote_account

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
      end
    end
  end

  def add_sharing
    Sharing.create!(user: self)
  end

  def add_empty_evernote_account
    EvernoteAccount.create!(user: self)
  end

  def connect_evernote(omniauth_response)
    puts '> Connecting evernote...'
    auth_token = omniauth_response['credentials']['token']
    evernote_account.update(auth_token: auth_token)
    puts '> Evernote connected!'
    SyncEvernoteAccount.enqueue(current_user.evernote_account.id)
  end

  def evernote_connected?
    evernote_account.connected?
  end
end
