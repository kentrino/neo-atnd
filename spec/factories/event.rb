FactoryGirl.define do
  factory :event do
    owner_id 1

    sequence(:title) { |n| "Ruby kaigi No.#{n}" }
    sequence(:hold_at) { |n| Time.zone.local(2016, 5, 12, n % 24, 0) }
    sequence(:capacity) { |n| n * 10 }
    sequence(:location) { |n| "Chiyotaku #{n} cho-me" }
    sequence(:owner) { |n| "No.#{n} owner" }
    sequence(:description) { |n| "No.#{n} description" }
  end
end
