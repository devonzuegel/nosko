class FindingsController < ApplicationController
  def index
    @findings = Finding.all
  end
end
