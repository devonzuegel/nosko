class VisitorsController < ApplicationController
  def index
    # if user_signed_in?
    #   if Finding::Article.count == 0
    #     current_user.evernote_account.sync if current_user.evernote_connected?
    #   end
    #   @articles = Finding::Article.where(user: current_user)
    # end
    #
    @articles = Finding::Article.take(30).map { |a| a.decorate.as_prop }
  end
end
