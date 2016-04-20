class Following < ActiveRecord::Base
  belongs_to :leader
  belongs_to :follower
end
