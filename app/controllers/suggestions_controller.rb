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
    redirect_to :calendar, flash: {success: "Suggestion \"#{@suggestion.suggestion_title}\" was created"}
  end

  def edit
    @suggestion = Suggestion.find(params[:id])
    render :new
  end

  def update
    @suggestion = Suggestions.find(params[:id])
    @suggestion.update_attributes(suggestion_params)
    @suggestion.save
    redirect_to suggestion_path(@suggestion), flash: {success: "Suggestion \"#{@suggestion.suggestion_title}\" was updated"}
  end

  def destroy
    oldtitle=Suggestion.find(params[:id]).suggestion_title
    Suggestion.find(params[:id]).destroy
    redirect_to suggestions_path, flash: {error: "Suggestion \"#{oldtitle}\" was deleted"}
  end

  def suggestion_params
    params[:suggestion].permit(:suggestion_title, :suggestion_description)
  end
end
