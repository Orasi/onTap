class SuggestionsController < ApplicationController
  def suggestioncollection
    @suggestions = Suggestion.all
  end
  
  def show
    @suggestion = Suggestion.find(params[:id])
  end  

  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion=Suggestion.create(suggestion_params)
    @suggestion.suggestor_id=current_user.id
    @suggestion.save
    redirect_to :calendar
  end

  def edit
    @suggestion = Suggestion.find(params[:id])
    render :new
  end

  def update
    @suggestion = Suggestions.find(params[:id])
    @suggestion.update_attributes(suggestion_params)
    @suggestion.save
    redirect_to suggestion_path(@suggestion)
  end

  def destroy
    Suggestion.find(params[:id]).destroy
    redirect_to :suggestioncollection
  end

  def suggestion_params
    params[:suggestion].permit(:suggestion_title, :suggestion_description)
  end
end
