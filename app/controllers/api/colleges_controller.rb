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

    # store proper noun version of college name for later
    # names = {}
 #    all_colleges.each do |college|
 #      names[college.name.downcase] = college.name
 #    end
 #
 #    @colleges = []
 #    names.keys.each do |name|
 #      if Regexp.new(match).match(name)
 #        name = names[name]
 #        college = all_colleges.select { |college| college.name == name }
 #        @colleges.push(college.first)
 #      end
 #    end

    render json: @colleges
  end
end
