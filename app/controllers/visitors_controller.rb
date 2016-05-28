class VisitorsController < ApplicationController
  def index
    if user_signed_in?
      @articles = Feed.new(current_user).findings.map { |a| a.decorate.as_prop }
    else
      @articles = Finding::Article.where(visibility: 'Public').limit(25)
    end
  end
end
