# frozen_string_literal: true

class EventUser < ActiveRecord::Base
  belongs_to :user, foreign_key: :attendee_user_id
  belongs_to :event
end
