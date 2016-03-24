class User < ActiveRecord::Base
  has_one :sharing, dependent: :destroy
  has_one :evernote_account, dependent: :destroy
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
end
