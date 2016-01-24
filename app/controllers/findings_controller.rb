class FindingsController < ApplicationController
  def create
    @finding = Finding.new(finding_params)
    if @finding.save
      render json: @finding
    else
      render json: @finding.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @finding = Finding.find(params[:id])
    ap @finding
    @finding.destroy
    head :no_content
  end

  def update
    @finding = Finding.find(params[:id])
    if @finding.update(finding_params)
      render json: @finding
    else
      render json: @finding.errors, status: :unprocessable_entity
    end
  end

  private

  def finding_params
    params.require(:finding).permit(:title, :url, :kind)
  end
end
