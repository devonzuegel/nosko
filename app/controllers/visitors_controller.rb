class VisitorsController < ApplicationController
  def index
    @findings = Finding.all
  end
end
