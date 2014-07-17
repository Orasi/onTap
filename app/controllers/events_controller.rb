class EventsController < ApplicationController

  def calendar
#    @lunchlearns = Lunchlearnchlearns.where("lunch_date >= ?",DateTime.now.to_date).order(lunch_date: :asc)
     @events=Event.all
  end
  
  def show
    @lunch = Lunchlearn.find(params[:id])
  end  

  def new
    @lunchlearn = Lunchlearn.new
  end

  def create
    params[:lunchlearn][:lunch_date] = DateTime.strptime(params[:lunchlearn][:lunch_date], "%m/%d/%Y")
    @lunch=Lunchlearn.new(lunchlearn_params)
    if @lunch.save
      redirect_to :calendar, flash: {success: "Event \"#{@lunch.title}\" was created"}
    else
      redirect_to :calendar, flash: {error: "Event \"#{@lunch.title}\" was not created"}
    end
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
    redirect_to lunchlearn_path(@lunch), flash: {success: "Event \"#{@lunch.title}\" was updated"}
  end

  def destroy
    oldEventTitle=Lunchlearn.find(params[:id]).title
    Lunchlearn.find(params[:id]).destroy
    redirect_to :calendar, flash: {error: "Event \"#{oldEventTitle}\" was deleted"}
  end
end
