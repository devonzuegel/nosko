class EvernoteController < ApplicationController
  before_filter :check_status, except: %i(sync)

  def new
    redirect_to '/auth/evernote'
  end

  def create
    ActiveRecord::Base.transaction do
      current_user.connect_evernote(request.env['omniauth.auth'])
      SyncEvernoteAccount.enqueue(current_user.evernote_account.id)
    end
    # TODO add error handling in case of bad account info
    redirect_to root_url, notice: 'Evernote connected!'
  end

  def sync
    ActiveRecord::Base.transaction do
      SyncEvernoteAccount.enqueue(current_user.evernote_account.id)
    end
    Que.wake_all!
    redirect_to root_url, notice: 'Evernote sync in progress!'
  end

  private

  def check_status
    authenticate_user!
    if current_user.evernote_connected?
      redirect_to root_url, notice: 'You have already connected your Evernote account!'
    end
  end
end
