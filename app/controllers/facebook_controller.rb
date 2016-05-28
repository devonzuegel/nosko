class FacebookController < ApplicationController
  def new
    redirect_to '/auth/facebook'
  end

  def create
    ap request.env['omniauth.auth']
    # current_user.connect_evernote(request.env['omniauth.auth'])

    # # TODO add error handling in case of bad account info
    redirect_to root_url, notice: 'Facebook not yet connected!'
  end

  private

  def check_status
    authenticate_user!
    if current_user.facebook_connected?
      redirect_to root_url, notice: 'You have already connected your Facebook account!'
    end
  end
end
