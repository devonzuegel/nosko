module Friendable
  extend ActiveSupport::Concern

  included do
    has_many :active_relationships,  class_name: 'Friendship', foreign_key: 'friendee_id', dependent: :destroy
    has_many :frienders, through: :active_relationships,  source: :friender

    has_many :passive_relationships, class_name: 'Friendship', foreign_key: 'friender_id', dependent: :destroy
    has_many :friendees, through: :passive_relationships, source: :friendee
  end

  def friends_with?(user)
    !friendship_with(user).nil?
  end

  def request_pending?(user)
    unconfirmed_friends.map(&:id).include? user.id
  end

  def friend!(friendee)
    if friendee == self
      errors[:base] << "You can't friend yourself, silly!"
      return false
    end

    if friends_with?(friendee)
      errors[:base] << "You're already friends with #{friendee.name}!"
      return false
    end

    if request_pending?(friendee)
      errors[:base] << "There's a pending friendship request with #{friendee.name} already!"
      return false
    end

    Friendship.create!(friender: self, friendee: friendee)
    true
  end

  def confirmed_friends
    [
      *Friendship.where(friendee: self).confirmed.map(&:friender),
      *Friendship.where(friender: self).confirmed.map(&:friendee)
    ]
  end

  def unconfirmed_friends
    [
      *Friendship.where(friendee: self).unconfirmed.map(&:friender),
      *Friendship.where(friender: self).unconfirmed.map(&:friendee)
    ]
  end

  def unfriend!(friend)
    friendship = friendship_with(friend)

    if !friends_with?(friend)
      errors[:base] << "You weren't friends with user ##{friend.id}"
      return false
    end

    friendship.destroy!
    true
  end

  private

  def friendship_with(friend)
    [
      *Friendship.where(friender: friend, friendee: self).confirmed,
      *Friendship.where(friender: self,   friendee: friend).confirmed
    ].first
  end
end