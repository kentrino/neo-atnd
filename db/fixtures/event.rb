require('./db/seed_max')

languages = %w(COBOL C Fortran Lisp Java JavaScript Perl PHP Haskell Go)
locations = %w(
  Monzennakacho
  Shibuya
  Shinjuku
  Asakusa
  Nihonbashi
  Roppongi
  Ebisu
  Ikebukuro
  Ginza
  Ueno
)

1.upto(EVENT_MAX) do |i|
  Event.seed do |e|
    e.id = i

    e.hold_at = Time.new(2016, 5, 12, i)

    e.title = "#{languages[i]} night!"
    e.capacity = i * 10
    e.location = "#{locations[i]}"
    e.description = "#{languages[i]}についてしゃべりながらお酒を飲む会"
    e.owner = "Owner No.#{i}"

    e.owner_id = i
  end
end
