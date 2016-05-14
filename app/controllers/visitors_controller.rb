class VisitorsController < ApplicationController
  def index
    #   if Finding::Article.count == 0
    #     current_user.evernote_account.sync if current_user.evernote_connected?
    #   end
    #   @articles = Finding::Article.where(user: current_user)
    # end

    if user_signed_in?
      @articles = Finding::Article.first(20).map { |a| a.decorate.as_prop }
    else
      @articles = []
    end
  end
end
