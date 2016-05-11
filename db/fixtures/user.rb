User.seed do |u|
  u.id = 1

  u.provider = 'twitter'
  u.uid = 1

  u.name = 'Ichiro'
  u.nickname = 'ichiro'
  u.image = 'https://pbs.twimg.com/profile_images/509105321189855233/EFIx-IE1_400x400.jpeg'
  u.description = 'First user'
end

2.upto(9) do |i|
  User.seed do |u|
    u.id = i

    u.provider = 'twitter'
    u.uid = i

    u.name = "#{i}ro"
    u.nickname = "twitter_id_#{i}"
    u.image = 'https://pbs.twimg.com/profile_images/509105321189855233/EFIx-IE1_400x400.jpeg'
    u.description = "I'm No.#{i} user"
  end
end
