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
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    ap params
    params.require(:user).permit(:name, sharing_attributes: Sharing::UPDATEABLE_ATTRIBUTES)
  end
end
