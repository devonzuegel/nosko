class VisitorsController < ApplicationController
  def index
    @evernote_notes = EvernoteNote.all
    # if Rails.env.development?
    #   puts "\nREMOVE THIS!!!!!!!!!!!!!!!!\n".red
    #   session[:user_id] = User.first.id
    # end
  end
end
