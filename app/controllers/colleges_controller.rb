class CollegesController < ApplicationController
  def index
    @colleges = College.all
    @header_text = "All Colleges"

    render :index
  end

  def show
    @college = College.find(params[:id])

    render :show
  end

  def search
    match = params[:match]
    all_colleges = College.all

    # store proper noun version of college name for later
    names = {}
    all_colleges.each do |college|
      names[college.name.downcase] = college.name
    end

    @colleges = []
    names.keys.each do |name|
      if Regexp.new(match).match(name)
        name = names[name]
        college = all_colleges.select { |college| college.name == name }
        @colleges.push(college.first)
      end
    end

    @header_text = 'Colleges that match "' + match.html_safe + '":'

    render :index
  end
end
