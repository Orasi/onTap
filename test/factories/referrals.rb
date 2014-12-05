# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :referral do
    refer_email ""
    refer_message "MyText"
  end
end
