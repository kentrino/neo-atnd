1.upto(9) do |user_id|
  EventUser.seed do |e|
    # shuffle user id for testing
    e.id = user_id
    e.event_id = 1

    attendee_user_id = user_id * 5 % 9 + 1
    e.attendee_user_id = attendee_user_id
    e.absent = attendee_user_id > 4
  end
end
