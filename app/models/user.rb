class User < ActiveRecord::Base
  belongs_to :sharing, dependent: :destroy
  accepts_nested_attributes_for :sharing
  before_create :add_sharing

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
    self.sharing = Sharing.create!
  end
end
