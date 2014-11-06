class Api::CollegesController < ApplicationController
  def index
    @colleges = College.order(:name).page(params[:page])

    render json: @colleges
  end

  def show
    @college = College.includes(:college_ratings).includes(:up_down_votes).find(params[:id])

    render :show
  end

  def search
    match = params[:match]
    @colleges = College.search_colleges(match)
    
    render json: @colleges
  end
end
