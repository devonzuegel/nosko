class VisitorsController < ApplicationController
  def index
    @articles = Article.all
    # if Rails.env.development?
    #   puts "\nREMOVE THIS!!!!!!!!!!!!!!!!\n".red
    #   session[:user_id] = User.first.id
    # end
  end
end
