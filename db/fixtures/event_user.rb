1.upto(9) do |user_id|
  EventUser.seed do |e|
    e.id = user_id
    e.event_id = 1
    e.attendee_user_id = user_id
    e.absent = user_id > 4
  end
end
