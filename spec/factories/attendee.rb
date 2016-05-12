FactoryGirl.define do
  factory :attendee, class: EventUser do
    sequence(:attendee_user_id) { |n| n }
  end
end
