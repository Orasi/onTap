class Template < ActiveRecord::Base
  include Skytap

  before_create :exists_in_skytap?

  def exists_in_skytap?
    json = api_call(request_type: 'get', request_path: '/templates/' + id.to_s )
    json['id'] === id.to_s
    print json
  end

  def create_environment(user)
      Environment.create(
          title: title + ' ' + user.username,
          expiration: DateTime.now + 3.hours,
          template_id: id,
          user_id: user.id,
          description: description,
          status: 'in queue'

      )
  end

end
