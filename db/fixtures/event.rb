Event.seed do |e|
  e.id = 1

  e.title = 'Event title 1 Ruby night'
  e.hold_at = Time.new(2016, 5, 12, 7, 1)
  e.capacity = 10
  e.location = 'Asakusa'
  e.description = 'Rubyについてしゃべりながら酒飲む'

  e.owner_id = 1
end

Event.seed do |e|
  e.id = 2

  e.title = 'Event title 2 Go night'
  e.hold_at = Time.new(2016, 5, 12, 7, 2)
  e.capacity = 20
  e.location = 'Shibuya'
  e.description = 'Goについてしゃべりながら酒飲む'

  e.owner_id = 2
end

3.upto(9) do |i|
  Event.seed do |e|
    e.id = i

    e.hold_at = Time.new(2016, 5, 12, 7, i)

    e.title = "Event title #{i}"
    e.capacity = i * 10
    e.location = "Location #{i}"
    e.description = "Language No.#{i}についてしゃべりながら酒飲む"

    e.owner_id = i
  end
end
