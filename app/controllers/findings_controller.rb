class FindingsController < ApplicationController
  before_action :find_permalink

  def show
    @article = Finding::Article.find_by(permalink: @permalink).decorate
    respond_to do |format|
      format.html
      format.json { render json: @article.as_prop, status: :ok }
    end
  end

  def lock
    a = Finding::Article.find_by(permalink: @permalink)
    a.lock!
    head :ok
  end

  def unlock
    a = Finding::Article.find_by(permalink: @permalink)
    a.unlock!
    head :ok
  end

  private

  def find_permalink
    @permalink = Permalink.find_by_path(params[:permalink])
    return unless @permalink.nil?

    respond_to do |format|
      format.html { render_404 }
      format.json { head :not_found }
    end
  end
end
