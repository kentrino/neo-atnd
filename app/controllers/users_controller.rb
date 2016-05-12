# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])

    return unless @user.nil?

    redirect_to events_path, alert: 'User does not exist.'
  end
end
