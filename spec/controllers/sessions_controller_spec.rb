require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'change' do
    it 'returns nothing' do
      ENV['APP_DEBUG'] = 'true'
      get 'change', user_id: 1
      session[:user_id].should eq '1'
    end
  end
end
