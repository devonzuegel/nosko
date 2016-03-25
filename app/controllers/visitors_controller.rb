class VisitorsController < ApplicationController
  def index
    # if user_signed_in?
    #   en_account = current_user.evernote_account
    #   @evernote_notes = EvernoteNote.where(evernote_account: en_account)
    #   evernote_account.sync_notes if current_user.evernote_connected?
    # else
      @evernote_notes = []
    # end
  end
end
