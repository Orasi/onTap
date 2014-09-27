class AttachmentsController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    @attachment = event.attachments.new
    @attachment.file_file_name = params[:filename]
    @attachment.file_content_type = params[:filetype]
    @attachment.file_file_size = params[:filesize]
    @attachment.direct_upload_url = params[:attachment][:direct_upload_url]

    if @attachment.save
      flash[:success] = 'Attachment Added to Event.'
    else
      flash[:error] = 'Attachment Failed to be added to event.  Errors:  ' + @attachment.errors.full_messages.to_s
    end

    redirect_to (:back)
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    title = @attachment.file_file_name
    @attachment.destroy
    flash[:error] = title + ' deleted from event'
    redirect_to (:back)
  end

  def download
    redirect_to Attachment.find(params[:id]).file.expiring_url(300)
  end

  private

  def attach_params
    params.require(:attachment).permit(:file, :title, :event_id)
  end
end
