class AttachmentsController < ApplicationController
  def create
    @attachment = Attachment.new( attach_params )
    if @attachment.save
      flash[:success] = "Attachment Added to Event"
    else
      flash[:error] = "Attachment Failed to be added to Event"
    end
    redirect_to (:back)
  end

  private

  def attach_params
    params.require(:attachment).permit(:file, :title, :lunchlearn_id)
  end
end
