class FriendshipsController < ApplicationController
  before_action :authenticate_user!, :find_friendee

  def friend
    # if current_user.follow!(@leader)
    #   head :ok
    # else
    #   render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    # end
  end

  def unfriend
    # if current_user.unfollow!(@leader)
    #   head :ok
    # else
    #   render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    # end
  end

  private

  def find_leader
    @friendee = User.find(params[:id])
  end
end
