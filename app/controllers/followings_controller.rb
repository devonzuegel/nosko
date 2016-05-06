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
      head :ok
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end
end
