class AttachmentsController < ApplicationController
  def create
    @attachment = Attachment.new( attach_params )
    if @attachment.save
      flash[:success] = "Attachment Added to Event."
    else
      flash[:error] = "Attachment Failed to be added to event.  Errors:  " + @attachment.errors.full_messages.to_s
    end
    redirect_to (:back)
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    title = @attachment.file_file_name
    @attachment.destroy
    flash[:error] = title + " deleted from event"
    redirect_to (:back)
  end
  private

  def attach_params
    params.require(:attachment).permit(:file, :title, :event_id)
  end
end
