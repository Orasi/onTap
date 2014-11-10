class LabsController < ApplicationController
  before_action :redirect_to_manage, only: [:show]
  before_action :redirect_from_manage, only: :manage
  def index
    @labs = Template.all
    @env = current_user.environment
  end

  def show
    @lab = Template.find(params[:id])
    @env = current_user.environment
  end

  def redirect_to_manage
    unless current_user.environment.nil?
      redirect_to manage_lab_path current_user.environment
    end
  end

  def redirect_from_manage
    if current_user.environment.nil?
      lab = Template.find(params[:id])
      redirect_to lab_path(lab)
    end
  end

  def manage
    @env = current_user.environment
    @lab = @env.template
  end

  def create_lab
    template = Template.find(params[:id])
    env = template.create_environment current_user
    if env.save
      render json: env
    else
      render json: env.errors.full_messages
    end
  end

  def delete_lab
    env = current_user.environment
    if env
      env.destroy
      redirect_to labs_path
    else
      #error....
    end
  end

  def lab_status
    lab = current_user.environment
    render json: lab
  end

  def generate_rdp_file
    env = Environment.find(params[:id])
    file ="screen mode id:i:2\ndesktopwidth:i:679\ndesktopheight:i:509\nsession bpp:i:16\nwinposstr:s:0,3,0,0,800,600\nfull address:s:<URL>\naddress:s:<URL>\n" \
          "compression:i:1\nkeyboardhook:i:2\naudiomode:i:0\nredirectdrives:i:0\nredirectprinters:i:0\nredirectcomports:i:0\nredirectsmartcards:i:0\n"  \
          "displayconnectionbar:i:1\nautoreconnection enabled:i:1\nusername:s:Administrator\ndomain:s:\nalternate shell:s:\nshell working directory:s:\n" \
          "disable wallpaper:i:1\ndisable full window drag:i:0\ndisable menu anims:i:0\ndisable themes:i:0\ndisable cursor setting:i:0\nbitmapcachepersistenable:i:1"

    file.gsub! "<URL>" , env.rdp_address
    send_data file, :filename => 'connection.rdp'
  end
end
