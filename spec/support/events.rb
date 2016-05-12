require('./db/seed_max')

def events
  # Adjust array index and record id
  [nil] + Event.where(id: 1..EVENT_MAX)
end
