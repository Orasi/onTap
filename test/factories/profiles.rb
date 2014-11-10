# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    food_pref "MyString"
    location "MyString"
    notification_settings "MyString"
  end
end
