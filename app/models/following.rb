class Following < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :leader,   class_name: 'User'

  validates_presence_of :follower_id, :leader_id
end
