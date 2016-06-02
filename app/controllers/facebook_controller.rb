class FacebookController < ApplicationController
  def new
    redirect_to '/auth/facebook'
  end

  def create
    current_user.facebook_account.connect(request.env['omniauth.auth'])
    redirect_to root_url, notice: 'Facebook connected!'
  end

  def messages

  end

  private

  def check_status
    authenticate_user!
    if current_user.facebook_connected?
      redirect_to root_url, notice: 'You have already connected your Facebook account!'
    end
  end
end
