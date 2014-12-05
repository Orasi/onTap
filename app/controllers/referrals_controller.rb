class ReferralsController < ApplicationController

  def new
    @referral=Referral.new
  end

  def create
    @referral = Referral.new(referral_params)
    unless @referral.save
 #     redirect_to :back, flash: { error: @referral.errors[:refer_email]}
      redirect_to :back, flash: { error: "Emails should be in the format name@domain.  Multiple emails should be seperate by commas."}
      return
    end
    email_referral
  end

  def referral_params
    params.require(:referral).permit(:refer_email, :refer_message, :refer_sender_id)
  end

  def email_referral

    if session[:current_user_id].to_i != referral_params[:refer_sender_id].to_i
      redirect_to :back, flash: { error: "Referral sender does not match current user"}
      return
    end

    @user=User.find(referral_params[:refer_sender_id])
    UserEmail.user_email(referral_params[:refer_email], "#{@user.display_name} has referred your to an event on onTap", referral_params[:refer_message]).deliver
    redirect_to :back, flash: { success: "Referral was sent" }
  end
end
