class RootController < ApplicationController
  def home
    render :home
  end
  
  def search
    match = params[:match]
    @matches = PgSearch.multisearch(match).includes(:searchable).map(&:searchable)
    
    render :search
  end
end