class ProfessorsController < ApplicationController
  before_filter :require_logged_in, only: [:new, :create]
  
  def index
    @professors = Professor.includes(:college).order(:last_name).page(params[:page])
    @header_text = "All Professors"

    render :index
  end

  def show
    @professor = Professor.find(params[:id])
    @ratings = @professor.professor_ratings.includes(:up_down_votes).page(params[:page])

    render :show
  end

  def new
    @professor = Professor.new
    @departments = Professor::DEPARTMENTS
    @colleges = College.all

    render :new
  end

  def create
    @professor = Professor.new(professor_params)

    if @professor.save
      flash[:notices] = ["Professor created!"]
      redirect_to professor_url(@professor)
    else
      @departments = Professor::DEPARTMENTS
      @colleges = College.all
      flash.now[:errors] = @professor.errors.full_messages
      render :new
    end
  end

  def search
    match = params[:match]
    @professors = Professor.search_professors(match).includes(:college)
    
    # match = params[:match]
#     all_professors = Professor.all
#
#     # store proper noun version of professor name for later
#     names = {}
#     all_professors.each do |professor|
#       cap = professor.name
#       down = cap.downcase
#       names[down] = cap
#     end
#
#     @professors = []
#     names.keys.each do |name|
#       if Regexp.new(match).match(name)
#         name = names[name]
#         professor = all_professors.select do |professor|
#           professor.name == name
#         end
#         @professors.push(professor.first)
#       end
#     end
#
    @header_text = 'Professors that match "' + match.html_safe + '":'

    render :index
  end

  private
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
