require('./db/seed_max')

FactoryGirl.define do
  factory :user do
    sequence(:uid) { |n| n }
    name 'hoge'
    nickname 'hige'
    image 'fuga'
    description 'faga'
    token 'fage'
    secret 'higa'
  end
end
