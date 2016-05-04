class FollowingsController < ApplicationController
  before_action :authenticate_user!

  def follow
    @leader = User.find(params[:id])

    if current_user.follow!(@leader)
      redirect_to :back, notice: "Followed user ##{@leader.id}"
    else
      redirect_to :back, alert: flash_errors(current_user)
    end
  end

  def unfollow
    @leader = User.find(params[:id])

    if current_user.unfollow!(@leader)
      redirect_to :back, notice: "Unfollowed user ##{@leader.id}"
    else
      redirect_to :back, alert: flash_errors(current_user)
    end
  end
end
