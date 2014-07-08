class LunchlearnsController < ApplicationController
  before_action :require_admin, only: [:new, :update, :destroy]
  after_action :add_hosts, only: [:create]
  after_action :update_hosts, only: [:update]

  def calendar
    @lunchlearns = Lunchlearn.where("lunch_date >= ?",DateTime.now.to_date).order(lunch_date: :asc)
  end
  
  def show
    @lunch = Lunchlearn.find(params[:id])
  end  

  def new
    @lunchlearn = Lunchlearn.new
  end

  def create
    params[:lunchlearn][:lunch_date] = DateTime.strptime(params[:lunchlearn][:lunch_date], "%m/%d/%Y")
    @lunch=Lunchlearn.create(lunchlearn_params)
    redirect_to :calendar, flash: {success: "Event Created"}
  end

  def edit
    @lunchlearn = Lunchlearn.find(params[:id])
    render :new
  end

  def update
    params[:lunchlearn][:lunch_date] = DateTime.strptime(params[:lunchlearn][:lunch_date], "%m/%d/%Y")
    @lunch = Lunchlearn.find(params[:id])
    @lunch.update_attributes(lunchlearn_params)
    @lunch.save
    redirect_to lunchlearn_path(@lunch), flash: {success: "Event Updated"}
  end

  def destroy
    Lunchlearn.find(params[:id]).destroy
    redirect_to :calendar, flash: {error: "Event Deleted"}
  end
  private

  def lunchlearn_params
    params[:lunchlearn].permit(:title, :description, :lunch_date, :lunch_time, :has_GoToMeeting, :meeting_phone_number, :access_code, :go_to_meeting_url)
  end

  def lunch_host_ids
    params.require(:lunchlearn).permit(hosts: [])
  end

  def add_hosts
    if !lunch_host_ids[:hosts].blank?
      lunch_host_ids[:hosts].each do |host_id|
        Host.create(lunchlearn: @lunch, user: User.find(host_id))
      end
    end
  end

  def update_hosts
    Host.where(lunchlearn: @lunch).delete_all
    if !lunch_host_ids[:hosts].blank?
      lunch_host_ids[:hosts].each do |host_id|
        Host.create(lunchlearn: @lunch, user: User.find(host_id))
      end
    end
  end


end
