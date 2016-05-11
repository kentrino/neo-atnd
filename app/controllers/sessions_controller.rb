# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to events_path
  end

  def destroy
    reset_session
    redirect_to events_path
  end

  def change
    session[:user_id] = params[:user_id] if ENV['DEBUG'] == 'true'

    render nothing: true
  end
end
