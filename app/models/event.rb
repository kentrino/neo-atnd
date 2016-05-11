# frozen_string_literal: true

class Event < ActiveRecord::Base
  belongs_to :user, foreign_key: :owner_id

  has_many :event_users
  has_many :_users, source: :user, through: :event_users

  default_scope -> { includes(:_users).order('created_at ASC') }

  def owner
    user.name
  end

  def owner?(current_user)
    user.id == current_user.id
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
    users.select { |u| !u.absent }
  end

  def absentees
    users.select(&:absent)
  end

  # returns whether current user will ATTEND AND BE PRESENT AT the event or not
  def attend?(current_user)
    return false if users.blank?
    @users_hash ||= Hash[*users.pluck(:id).zip(users).flatten]
    !@users_hash[current_user.id].nil? && !@users_hash[current_user.id].absent
  end

  private

  def prepare_user_hash
  end
end
