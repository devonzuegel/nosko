class VisitorsController < ApplicationController
  before_action :authenticate_user!, only: %i(activity_log)

  def index
    puts "\n\n#{Rails.root}\n\n".red
    @articles = Feed.new(current_user).findings
  end

  def activity
    @unreviewed_findings = ActivityLog.new(current_user).unreviewed
    @reviewed_findings   = ActivityLog.new(current_user).reviewed
  end
end
