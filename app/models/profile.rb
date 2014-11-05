class Profile < ActiveRecord::Base
  belongs_to :user

  def self.new_user_profile(userid)
    @profile=User.find(userid).build_profile(food_pref: "Not Set", location: "Not Set", notification_settings: "Not Set")
    @profile.save
  end
end
