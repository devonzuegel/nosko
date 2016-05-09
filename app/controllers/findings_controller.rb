class FindingsController < ApplicationController
  def show
    @finding = Permalink.find_by_path(params[:permalink])
    render json: @finding, status: :success
  end
end
