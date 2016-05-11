Event.seed do |e|
  e.id = 1

  e.title = 'Event title 1'
  e.capacity = 10
  e.location = 'Asakusa'
  e.description = 'Rubyについてしゃべりながら酒飲む'

  e.owner_id = 1
end


Event.seed do |e|
  e.id = 2

  e.title = 'Event title 2'
  e.capacity = 20
  e.location = 'Shibuya'
  e.description = 'Golangについてしゃべりながら酒飲む'

  e.owner_id = 2
end

3.upto(9) do |i|
  Event.seed do |e|
    e.id = i

    e.title = "Event title #{i}"
    e.capacity = i * 10
    e.location = "Location #{i}"
    e.description = "Language No.#{i}についてしゃべりながら酒飲む"

    e.owner_id = i
  end
end
