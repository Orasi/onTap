module EventsHelper
  def get_flash_for_user
    flashmessage = ''
    if User.find(session[:current_user_id]).check_if_admin?
      @notifications = Notification.where(notification_type: 'attendance', status: ['new'])
      if @notifications.count > 0
        @notifications.each do |notification|
          flashmessage += "#{User.find(notification.user_id).display_name} is requesting to attend the event #{Event.find(notification.event_id).title}.  #{link_to 'Approve ', approve_attend_path(id: notification.id)}  #{link_to 'Reject', reject_attend_path(id: notification.id)}  #{link_to 'Details ', notifications_path}<br />"
        end
      end
    end
    @notifications = Notification.where(user_id: session[:current_user_id], notification_type: 'attendance', status: %w(approved rejected))
    if @notifications.count > 0
      @notifications.each do |notification|
        if (notification.status == 'approved')
          flashmessage += "#{User.find(notification.manager_id).display_name} has approved your request to attend event #{Event.find(notification.event_id).title}.  #{link_to 'Remove.', notification_path(id: notification.id), method: :delete} #{link_to 'Add To Calendar', event_invite_path(Event.find(notification.event_id)), class: 'invite_link', remote: true}<br />"
        else
          flashmessage += "#{User.find(notification.manager_id).display_name} has rejected your request to attend event #{Event.find(notification.event_id).title}.  #{link_to 'Remove', notification_path(id: notification.id), method: :delete}<br />"
        end
      end
    end

    @notifications = Notification.where(notification_type: 'survey', status: ['new'], user_id: session[:current_user_id])
    if  @notifications.count > 0
      @notifications.each do |notification|
        flashmessage += "You have a new survey to take for #{Event.find(notification.event_id).title}. #{link_to 'Click here to take the survey now! ', new_survey_path(event_id: notification.event_id)}<br />"
      end
    end
    unless flashmessage.blank?
      flash.now[:success] = flashmessage.html_safe
    end
  end

  def check_for_notifications
    Notification.exists?(user_id: session[:current_user_id])
  end


  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_func(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
  link_to_func(name, ("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end


  def link_to_func(name, *args, &block)
     html_options = args.extract_options!.symbolize_keys

     function = block_given? ? update_page(&block) : args[0] || ''
     onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
     href = html_options[:href] || '#'

     content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

  def build_department_tree(department_hash)
    
  end

end
