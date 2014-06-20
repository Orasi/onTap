class LunchlearnsController < ApplicationController
  def calendar
    @lunchlearns = Lunchlearn.all
  end
  
  def show
    @lunch = Lunchlearn.find(params[:id])
  end  

  def new
    @lunchlearn = Lunchlearn.new
  end

  def create
    Lunchlearn.create(lunchlearn_params)
    redirect_to :calendar
  end

  def edit
    @lunchlearn = Lunchlearn.find(params[:id])
    render :new
  end

  def update
    @lunch = Lunchlearn.find(params[:id])
    @lunch.update_attributes(lunchlearn_params)
    @lunch.save
    redirect_to lunchlearn_path(@lunch)
  end

  def destroy
    Lunchlearn.find(params[:id]).destroy
    redirect_to :calendar
  end
  private

  def lunchlearn_params
    params[:lunchlearn].permit(:title, :description)
  end
end
