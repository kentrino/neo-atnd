# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :prepare_event, except: [:create, :index, :new]
  before_action :authenticate_user!, only: [:create]
  before_action :authenticate_owner!, only: [:edit, :update, :destroy]

  def index
    # avoid taking user records
    @events = Event.unscoped.all
    render css: true
  end

  def create
    @event = Event.new(event_params)
    @event.owner_id = current_user.id
    if @event.save
      redirect_to event_path(@event)
    else
      render :new, css: true
    end
  end

  def new
    @event = Event.new
  end

  def edit
    render :new, css: true
  end

  def show
    render css: true
  end

  def update
    if @event.update_attributes(event_params)
      redirect_to event_path(@event)
    else
      render :new, css: true
    end
  end

  def destroy
    if @event.destroy
      flash[:notice] = "Event: #{@event.title} was successfully deleted"
      redirect_to events_path
    else
      flash[:alert] = 'Event Delete Failed.'
    end
  end

  private

  def authenticate_owner!
    authenticate_user!

    return if @event.owner_id == current_user.id

    redirect_to event_path(@event)
  end

  def event_params
    return nil if params[:event].nil?
    params.require(:event).permit(
      :title,
      :capacity,
      :location,
      :owner,
      :description
    )
  end

  def prepare_event
    event_id = params[:id]
    @event ||= Event.find_by(id: event_id)

    return unless @event.nil?

    @event.nil?
    flash[:alert] = 'Event not found'
    redirect_to events_path
  end
end
