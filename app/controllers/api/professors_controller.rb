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
      flash[:notices] = ["Professor created!"]
      redirect_to "#" + professor_path(@professor)
    else
      flash[:errors] = @professor.errors.full_messages
      redirect_to "#/professors/new"
    end
  end

  def search
    match = params[:match]
    @professors = Professor.search_professors(match).includes(:college)

    render :index
  end
  
  private
  def require_logged_in
    unless logged_in?
      flash[:errors] = ["Must be logged in to create a professor ratings"]
      redirect_to "#" + new_session_path
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
