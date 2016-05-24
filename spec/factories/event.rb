FactoryGirl.define do
  factory :event_user do
  end

  factory :event do
    sequence(:title) { |n| "Ruby kaigi No.#{n}" }
    sequence(:hold_at) { |n| Time.zone.local(2016, 5, 12, n % 24, 0) }
    sequence(:capacity) { |n| n * 10 }
    sequence(:location) { |n| "Chiyotaku #{n} cho-me" }
    sequence(:description) { |n| "No.#{n} description" }

    user

    after(:create) do |event, evaluator|
      event.attendees = evaluator.attendees
      event.absentees = evaluator.absentees
    end
  end
end
