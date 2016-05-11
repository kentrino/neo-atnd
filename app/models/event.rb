# frozen_string_literal: true

class Event < ActiveRecord::Base
  belongs_to :user
  has_many :_users, source: :user, through: :event_users
end
