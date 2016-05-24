# frozen_string_literal: true

class Event < ActiveRecord::Base
  belongs_to :user, foreign_key: :owner_id, class_name: User

  has_many :event_users
  has_many :absentees, -> { where 'event_users.absent = 1' }, through: :event_users, source: :user
  has_many :attendees, -> { where 'event_users.absent = 0' }, through: :event_users, source: :user

  validates :title, length: { maximum: 255 }
  validates :capacity, numericality: :only_integer
  validates :location, length: { maximum: 255 }
  validates :owner, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }

  def owner?(current_user)
    user && current_user && user.id == current_user.id
  end

  def owner_name
    user.name
  end

  # returns whether current user will ATTEND AND BE PRESENT AT the event or not
  def attend?(user)
    attendees.include?(user)
  end
end
