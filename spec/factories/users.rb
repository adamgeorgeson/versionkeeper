# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'example@sage.com'
    password 'changeme'
    password_confirmation 'changeme'
    # required if the devise confirmable module is used
    # confirmed_at time.now
  end
  factory :invalid_user do
    email 'example@example.com'
    password 'changeme'
    password_confirmation 'changeme'
    # required if the devise confirmable module is used
    # confirmed_at time.now
  end
end
