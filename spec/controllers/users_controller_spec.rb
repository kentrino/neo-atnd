require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  describe 'show' do
    let(:invalid_user_id) { 0 }
    let(:user) { create :user }

    context 'valid user' do
      it 'render correct user page' do
        get :show, id: user.id
        response.body.should match user.name
      end
    end

    context 'invalid user' do
      it 'render correct user page' do
        get :show, id: invalid_user_id
        response.should redirect_to events_path
        flash[:alert].should_not be_nil
      end
    end
  end
end
