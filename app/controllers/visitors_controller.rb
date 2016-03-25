class VisitorsController < ApplicationController
  def index
    if user_signed_in?
      en_account = current_user.evernote_account
      en_account.sync_notes if current_user.evernote_connected?
      @articles = Article.where(user: current_user)
    else
      @articles = []
    end
  end
end
