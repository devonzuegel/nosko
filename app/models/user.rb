class User < ActiveRecord::Base
  include Followable

  has_one  :facebook_account, dependent: :destroy
  has_one  :evernote_account, dependent: :destroy
  has_many :articles,   class_name: 'Finding::Article', dependent: :destroy

  has_one :sharing, dependent: :destroy
  accepts_nested_attributes_for :sharing, :evernote_account

  after_create :create_default_associations

  def findings
    Finding::Collection.new(self).all
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name'] || '' if auth['info']
    end
  end

  def connect_evernote(omniauth_response)
    Rails.logger.debug '> Connecting Evernote...'
    auth_token = omniauth_response['credentials']['token']

    evernote_account.update(auth_token: auth_token)
    Rails.logger.debug '> Evernote connected!'

    SyncEvernoteAccount.enqueue(evernote_account.id)
  end

  def connect_facebook(omniauth_response)
    facebook_account.connect(omniauth_response)
  end

  def evernote_connected?
    evernote_account.connected?
  end

  def facebook_connected?
    facebook_account.connected?
  end

  private

  def create_default_associations
    Sharing.create!         user: self
    EvernoteAccount.create! user: self
    FacebookAccount.create! user: self
  end
end
