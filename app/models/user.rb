class User < ActiveRecord::Base
  # Evernote account
  has_one  :evernote_account, dependent: :destroy

  # Articles
  has_many :articles,   class_name: 'Finding::Article', dependent: :destroy

  # Followings
  has_many :followers,  class_name: 'Following', foreign_key: 'leader_id'
  has_many :followings, class_name: 'Following', foreign_key: 'follower_id'

  # Sharing preferences
  has_one :sharing, dependent: :destroy
  accepts_nested_attributes_for :sharing, :evernote_account

  after_create :create_default_associations

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
    puts '> Connecting evernote...'
    auth_token = omniauth_response['credentials']['token']
    evernote_account.update(auth_token: auth_token)
    puts '> Evernote connected!'
    SyncEvernoteAccount.enqueue(evernote_account.id)
  end

  def evernote_connected?
    evernote_account.connected?
  end

  private

  def create_default_associations
    Sharing.create!(user: self)
    EvernoteAccount.create!(user: self)
  end
end
