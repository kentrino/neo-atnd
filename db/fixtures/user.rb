require('./db/seed_max')

roman = %w(Zero Ichi Ni Sabu Shi Go Roku Shichi Hachi Kyu Ju) + (11..20).to_a

1.upto(USER_MAX) do |i|
  User.seed do |u|
    u.id = i

    u.provider = 'twitter'
    u.uid = i

    u.name = "#{roman[i]}ro"
    u.nickname = "twitter_id_#{i}"
    u.image = 'https://pbs.twimg.com/profile_images/509105321189855233/EFIx-IE1_400x400.jpeg'
    u.description = "I'm No.#{i} user"
  end
end
