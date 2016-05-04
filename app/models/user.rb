class User < ActiveRecord::Base
  # Evernote account
  has_one  :evernote_account, dependent: :destroy

  # Articles
  has_many :articles,   class_name: 'Finding::Article', dependent: :destroy

  # Followings
  has_many :active_relationships,  class_name: 'Following', foreign_key: 'follower_id', dependent: :destroy
  has_many :leaders, through: :active_relationships,  source: :leader

  has_many :passive_relationships, class_name: 'Following', foreign_key: 'leader_id',   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # Sharing preferences
  has_one :sharing, dependent: :destroy
  accepts_nested_attributes_for :sharing, :evernote_account

  after_create :create_default_associations

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name'] || '' if auth['info']
    end
  end

  def connect_evernote(omniauth_response)
    Rails.logger.debug '> Connecting evernote...'
    auth_token = omniauth_response['credentials']['token']

    evernote_account.update(auth_token: auth_token)
    Rails.logger.debug '> Evernote connected!'

    SyncEvernoteAccount.enqueue(evernote_account.id)
  end

  def evernote_connected?
    evernote_account.connected?
  end

  def follows?(user)
    leaders.include? user
  end

  def follow!(user)
    Following.create!(leader: user, follower: self)
  end

  def unfollow!(leader)
    matches = Following.where(leader: leader, follower: self)
    if matches.empty?
      false
    else
      matches.first.destroy!
      true
    end
  end

  private

  def create_default_associations
    Sharing.create!(user: self)
    EvernoteAccount.create!(user: self)
  end
end
