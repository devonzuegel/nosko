class UsersController < ApplicationController
  before_action :authenticate_user!, only: %(settings)
  before_action :correct_user?, only: %(update)

  def index
    @users = User.all
  end

  def show
    user = User.find(params[:id])
    send_fb_message

    @user = user.decorate
    @feed = ProfileFeed.new(user, current_user).findings.map { |a| a.decorate.as_prop }
    @current_user = CurrentUserDecorator.new(current_user)
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

  def send_fb_message
    uid = FacebookAccount.first.uid
  end
end
