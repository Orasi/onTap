class Profile < ActiveRecord::Base
  belongs_to :user

  def self.new_user_profile(userid)
    @profile=User.find(userid).build_profile(food_pref: "None", location: "Other", notification_settings: "True")
    @profile.save
  end
end
