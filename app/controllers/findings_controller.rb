class FindingsController < ApplicationController
  def show
    permalink = Permalink.find_by_path(params[:permalink])
    if permalink.nil?
      respond_to do |format|
        format.html { render_404 }
        format.json { head :not_found }
      end
    else
      @article = Finding::Article.find_by(permalink: permalink).decorate
      respond_to do |format|
        format.html
        format.json { render json: @article.as_prop, status: :ok }
      end
    end
  end
end
