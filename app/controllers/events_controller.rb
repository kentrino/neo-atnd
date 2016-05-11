# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    # avoid taking user records
    @events = Event.unscoped.all
    render(css: true)
  end

  def create
  end

  def new
  end

  def edit
  end

  def show
    event_id = params[:id]
    @event = Event.find_by(id: event_id)
    render(css: true)
  end

  def update
  end

  def destroy
  end
end
