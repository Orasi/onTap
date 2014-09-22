class SurveysController < ApplicationController
  before_action :survey_required_for_user, only: [:new]
  before_action :require_host_or_admin, only: [:index]

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

  private
  def survey_required_for_user
    if Notification.where(user_id: session[:current_user_id], event_id: params[:event_id], notification_type: "survey").blank?
      redirect_to :calendar, flash: { error: 'No survey for you to take for this event' }  
    end
  end

  def require_host_or_admin
    unless Event.find(params[:id]).hosting_or_above?(User.find(session[:current_user_id]))
      redirect_to :calendar, flash: { error: 'Must be a host or admin to view these surveys' }  
    end
  end
end
