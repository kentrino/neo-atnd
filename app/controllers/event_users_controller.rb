# frozen_string_literal: true

class EventUsersController < ApplicationController
  def create
    event_user = EventUser.find_or_create_by(event_id: params[:id], attendee_user_id: current_user.id)
    event_user.absent = false
    event_user.save

    redirect_to event_path(id: params[:id])
  end

  def absent
    event_user = EventUser.find_by(event_id: params[:id], attendee_user_id: current_user.id)
    event_user.absent = true
    event_user.save

    redirect_to event_path(id: params[:id])
  end
end
