class FindingsController < ApplicationController
  before_action :authenticate_user!, except: %i(show)
  before_action :find_permalink

  def show
    @article = Finding::Article.find_by(permalink: @permalink).decorate
    respond_to do |format|
      format.html
      format.json { render json: @article.as_prop, status: :ok }
    end
  end

  def lock
    article = Finding::Article.find_by(permalink: @permalink)
    article.lock!
    head :ok
  end

  def unlock
    article = Finding::Article.find_by(permalink: @permalink)
    article.unlock!
    head :ok
  end

  def update
    @article = Finding::Article.find_by(permalink: @permalink)

    if !@article.owned_by?(current_user)
      head :unauthorized
    elsif @article.update(article_params)
      render json: @article.decorate.as_prop
    else
      render json: @article.errors, status: :unprocessable_entity
    end
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

  def article_params
    filtered = params.require(:article).permit(*%i(visibility reviewed favorited))
  end
end
