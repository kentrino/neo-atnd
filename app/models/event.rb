# frozen_string_literal: true

class Event < ActiveRecord::Base
  belongs_to :user, foreign_key: :owner_id

  has_many :event_users
  has_many :_users, source: :user, through: :event_users

  validates :title, length: { maximum: 255 }

  default_scope -> { includes(:_users) }

  def owner?(current_user)
    !user.nil? && !current_user.nil? && user.id == current_user.id
  end

  def users_called?
    @users_called
  end

  def users
    if users_called?
      @users
    else
      @users_called = true
      _users.each.with_index do |u, i|
        u.absent = event_users[i].absent
      end
      @users = _users
    end
  end

  def attendees
    users.select { |u| attend?(u) }
  end

  def absentees
    users.select { |u| !attend?(u) }
  end

  # returns whether current user will ATTEND AND BE PRESENT AT the event or not
  def attend?(user)
    return false if user.blank? || users.blank?

    @users_hash ||= Hash[*users.pluck(:id).zip(users).flatten]
    !@users_hash[user.id].nil? && !@users_hash[user.id].absent
  end
end
