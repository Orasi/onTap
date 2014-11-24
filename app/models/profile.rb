class Profile < ActiveRecord::Base
  belongs_to :user
  validates_inclusion_of :notification_settings, in: [true, false]

  def self.new_user_profile(userid)
    @profile=User.find(userid).build_profile(food_pref: "None", location: "Other", notification_settings: true)
    @profile.save
  end
end
