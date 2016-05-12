require('./db/seed_max')

FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| n + USER_MAX }
    sequence(:uid) { |n| n + USER_MAX }
    name 'hoge'
    nickname 'hige'
    image 'fuga'
    description 'faga'
    token 'fage'
    secret 'higa'
  end
end
