USER_COUNT = User.count

FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| n + USER_COUNT }
    sequence(:uid) { |n| n + USER_COUNT }
    name 'hoge'
    nickname 'hige'
    image 'fuga'
    description 'faga'
    token 'fage'
    secret 'higa'
  end
end
