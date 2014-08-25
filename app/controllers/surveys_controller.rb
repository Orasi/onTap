class SurveysController < ApplicationController

  def index
    @surveys=Survey.where(event_id: params[:event_id])
  end

  def show
    @survey=Survey.find(params[:event_id])
  end

  def new()
    @survey=Survey.new()
  end

  def create
    @survey = Event.find(params[:event_id]).surveys.new(event_params)
    unless @survey.save
      redirect_to :calendar, flash: {error: "Survey  was not created"}
      return
    end
    redirect_to :calendar, flash: {success: "Event \"#{@event.title}\" was created"}
  end

  def survey_params
    params.require(:event).permit(:went_well, :improved, :host_knowledge, :host_presentation, :effect, :extra)
  end
end
