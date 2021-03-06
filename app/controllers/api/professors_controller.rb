class Api::ProfessorsController < ApplicationController
  before_filter :require_logged_in, only: :create
  
  def index
    @professors = Professor.includes(:college).all

    render :index
  end

  def show
    @professor = Professor.includes(:professor_ratings).find(params[:id])

    render :show
  end

  def create
    @professor = Professor.new(professor_params)

    if @professor.save
      # redirect_to "#" + professor_path(@professor)
      render json: @professor
    else
      # redirect_to "#/professors/new"
      render json: @professor.errors.full_messages
    end
  end

  def search
    match = params[:match]
    @professors = Professor.search_professors(match).includes(:college)

    render :index
  end
  
  def is_valid
    @professor = Professor.new(professor_params)
    
    if @professor.valid?
      render json: @professor
    else
      render json: @professor.errors.full_messages
    end
  end
  
  private
  def require_logged_in
    unless logged_in?
      render json: "Must be logged in"
    end
  end
  
  def professor_params
    params.require(:professor).permit(
                                  :first_name,
                                  :middle_initial,
                                  :last_name,
                                  :department,
                                  :college_id,
                                  :filepicker_url
                                  )
  end
end
