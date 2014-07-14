class ArchiveController < ApplicationController
  before_action :require_admin, only: [:update, :destroy]

  def index
    @lunchlearns = Lunchlearn.where("lunch_date < ?",DateTime.now.to_date).order(lunch_date: :desc)
  end
  
  def show
    redirect_to show_lunchlearn_path
  end  

  def edit
    redirect_to edit_lunchlearn_path
  end

  def update
    redirect_to update_lunchlearn_path
  end

  def destroy
    redirect_to destroy_lunchlearn_path
    #redirect to archive here?
  end
end