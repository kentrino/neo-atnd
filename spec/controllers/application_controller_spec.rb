require 'rails_helper'

# TODO: refactor
RSpec.describe ApplicationController, type: :controller do
  controller do
    def _current_user
      render json: { return_value: current_user }
    end

    def _logged_in
      render json: { return_value: logged_in? }
    end

    def _authenticate_user
      render json: { return_value: authenticate_user! }
    end

    def authenticate_user
      authenticate_user!
    end
  end

  before do
    @routes.draw do
      get '/anonymous/_current_user'
      get '/anonymous/_logged_in'
      get '/anonymous/_authenticate_user'
      get '/anonymous/authenticate_user'
    end
  end

  let(:user) do
    User.find_by(id: 1)
  end

  describe 'current_user' do
    context 'have valid session' do
      it 'returns correct current user' do
        session[:user_id] = user.id

        get :_current_user

        return_value = JSON.parse(response.body, symbolize_names: true)[:return_value]

        return_value[:id].should eq user.id
      end
    end
  end

  describe 'logged_in?' do
    context 'have valid session' do
      it 'returns true' do
        session[:user_id] = user.id

        get :_logged_in

        return_value = JSON.parse(response.body, symbolize_names: true)[:return_value]

        return_value.should eq true
      end
    end
  end

  describe 'authenticate' do
    context 'have valid session' do
      it 'returns nothing' do
        session[:user_id] = user.id

        get :_authenticate_user

        return_value = JSON.parse(response.body, symbolize_names: true)[:return_value]

        return_value.should eq nil
      end
    end

    context 'have invalid session' do
      it 'returns nothing' do
        session = nil

        get :authenticate_user

        response.should redirect_to events_path
      end
    end
  end
end
