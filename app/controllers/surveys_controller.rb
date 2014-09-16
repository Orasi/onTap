class SurveysController < ApplicationController
  def index
    @surveys = Survey.where(event_id:  params[:id])
  end

  def new
    @survey = Event.find(params[:event_id]).surveys.new
  end

  def create
    @survey=User.find(session[:current_user_id]).surveys.new(survey_params)
    unless @survey.save
      redirect_to :calendar, flash: { error: 'Survey  was not created' }
      return
    end
    Notification.find_by(event_id: @survey.event_id, user_id: @survey.user_id).destroy
    redirect_to :calendar, flash: { success: "Event survey was submitted" }
  end

  def survey_params
    params.require(:survey).permit(:went_well, :improved, :host_knowledge, :host_presentation, :effect, :extra, :event_id)
  end
end
