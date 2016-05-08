class FollowingsController < APIController
  before_action :authenticate_user!

  def follow
    @leader = User.find(params[:id])

    if current_user.follow!(@leader)
      head :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unfollow
    @leader = User.find(params[:id])

    if current_user.unfollow!(@leader)
      head :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
