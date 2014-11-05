class Api::RootController < ApplicationController
  def search
    match = params[:match]
    @matches = PgSearch.multisearch(match).includes(:searchable).map(&:searchable)
    
    render :search
  end
end