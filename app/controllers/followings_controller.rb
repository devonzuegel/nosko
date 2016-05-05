class FollowingsController < ApplicationController
  before_action :authenticate_user!

  def follow
    @leader = User.find(params[:id])

    if current_user.follow!(@leader)
      head :ok
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def unfollow
    @leader = User.find(params[:id])

    if current_user.unfollow!(@leader)
      # render json: "Unfollowed user ##{@leader.id}"
      redirect_to :back, notice: "Unfollowed user ##{@leader.id}"
    else
      # render json: flash_errors(current_user)
      redirect_to :back, alert: flash_errors(current_user)
    end
  end
end
