class FindingsController < ApplicationController
  def show
    permalink      = Permalink.find_by_path(params[:permalink])
    @article       = Finding::Article.find_by(permalink: permalink)
    @other_finding = nil

    @finding = @article || @other_finding
    respond_to do |format|
      format.html { render_404 if @finding.nil? }
      format.json { render json: @finding, status: :ok }
    end
  end
end
