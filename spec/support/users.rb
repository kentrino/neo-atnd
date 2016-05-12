require('./db/seed_max')

def users
  # Adjust array index and record id
  [nil] + User.where(id: 1..USER_MAX)
end
