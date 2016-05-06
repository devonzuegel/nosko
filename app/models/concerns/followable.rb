module Followable
  extend ActiveSupport::Concern

  included do
    has_many :active_relationships,  class_name: 'Following', foreign_key: 'follower_id', dependent: :destroy
    has_many :leaders, through: :active_relationships,  source: :leader

    has_many :passive_relationships, class_name: 'Following', foreign_key: 'leader_id',   dependent: :destroy
    has_many :followers, through: :passive_relationships, source: :follower
  end

  def follows?(user)
    leaders.map(&:id).include? user.id
  end

  def follow!(leader)
    if leader == self
      errors[:base] << "You can't follow yourself, silly!"
      return false
    end

    matches = Following.where(leader: leader, follower: self)
    if !matches.empty?
      errors[:base] << "You're already following user ##{leader.id}"
      return false
    end

    Following.create!(leader: leader, follower: self)
    true
  end

  def unfollow!(leader)
    matches = Following.where(leader: leader, follower: self)

    if matches.empty?
      errors[:base] << "You weren't following user ##{@leader.id}"
      return false
    end

    matches.first.destroy!
    true
  end
end