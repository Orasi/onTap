class SuggestionsController < ApplicationController
  
  before_action :require_admin, only: [:index]

  def index
    @suggestions = Suggestion.all
  end
  
  def show
    @suggestion = Suggestion.find(params[:id])
  end  

  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion=User.find(current_user.id).suggestions.create(suggestion_params)
    redirect_to :calendar, flash: {success: "Suggestion Created"}
  end

  def edit
    @suggestion = Suggestion.find(params[:id])
    render :new
  end

  def update
    @suggestion = Suggestions.find(params[:id])
    @suggestion.update_attributes(suggestion_params)
    @suggestion.save
    redirect_to suggestion_path(@suggestion), flash: {success: "Suggestion Updated"}
  end

  def destroy
    Suggestion.find(params[:id]).destroy
    redirect_to suggestions_path
  end

  def suggestion_params
    params[:suggestion].permit(:suggestion_title, :suggestion_description)
  end
end
