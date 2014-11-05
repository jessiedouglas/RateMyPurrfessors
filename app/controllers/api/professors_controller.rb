class Api::ProfessorsController < ApplicationController
  before_filter :require_logged_in, only: [:new, :create]
  
  def index
    @professors = Professor.includes(:college).all

    render :index
  end

  def show
    @professor = Professor.includes(:professor_ratings).find(params[:id])

    render :show
  end

  # def new
#     @professor = Professor.new
#     @departments = Professor::DEPARTMENTS
#     @colleges = College.all
#
#     render json: @professor
#   end

  def create
    @professor = Professor.new(professor_params)

    if @professor.save
      flash[:notices] = ["Professor created!"]
      redirect_to root_url + "#" + professor_path(@professor)
    else
      flash[:errors] = @professor.errors.full_messages
      redirect_to root_url + "#/professors/new"
    end
  end

  def search
    match = params[:match]
    @professors = Professor.search_professors(match).includes(:college)

    render :index
  end
  
  private
  def professor_params
    params.require(:professor).permit(
                                  :first_name,
                                  :middle_initial,
                                  :last_name,
                                  :department,
                                  :college_id
                                  )
  end
end
