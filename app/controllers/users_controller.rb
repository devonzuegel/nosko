class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, only: %(update)

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def settings
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(modified_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def follow
    @leader = User.find(params[:id])
    Following.create!(leader: @leader, follower: current_user)
    redirect_to :back, notice: "Followed user ##{@leader.id}"
  end

  def unfollow
    @leader = User.find(params[:id])
    Following.create!(leader: @leader, follower: current_user)
    redirect_to :back, notice: "Followed user ##{@leader.id}"
  end

  private

  def user_params
    params.require(:user).permit(:name, sharing_attributes: Sharing::UPDATEABLE_ATTRIBUTES)
  end

  def modified_params
    params = user_params.deep_symbolize_keys
    if params[:sharing]
      share_by_default = params[:sharing][:share_by_default]
      params[:sharing_attributes] = params[:sharing]
      params[:sharing_attributes][:share_by_default] = (share_by_default == 'true') ? true : false
      params.delete('sharing')
    end
    params
  end
end
