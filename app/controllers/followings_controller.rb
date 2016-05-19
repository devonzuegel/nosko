class FollowingsController < ApplicationController
  before_action :authenticate_user!, :find_leader

  def follow
    if current_user.follow!(@leader)
      head :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unfollow
    if current_user.unfollow!(@leader)
      head :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_leader
    @leader = User.find(params[:id])
  end
end
