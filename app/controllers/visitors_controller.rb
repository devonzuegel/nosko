class VisitorsController < ApplicationController
  def index
    @articles = Feed.new(current_user).findings
  end
end
