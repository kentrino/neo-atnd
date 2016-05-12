require 'rails_helper'

def event_params(event)
  {
    title: event.title,
    capacity: event.capacity,
    location: event.location,
    owner: event.owner,
    description: event.description
  }
end

RSpec.describe EventsController, type: :controller do
  render_views

  let(:event) do
    create :event
  end

  describe 'index' do
    it 'should be rendered correctly' do
      get :index
      response.body.should match events[1].title
      response.body.should match events[EVENT_MAX].title
    end
  end

  describe 'new' do
    before do
      login! users[1]
    end

    it 'should be rendered correctly' do
      get :new
      response.body.should match 'createButton'
    end
  end

  describe 'edit' do
    before do
      login! users[1]
    end

    it 'should be rendered correctly' do
      get :edit, id: 1
      response.body.should match 'updateButton'
    end
  end

  describe 'create' do
    before do
      login! users[1]
    end

    context 'valid event params' do
      it 'redirect to event path' do
        mock_event = event
        post :create, event: event_params(mock_event)
        auto_incremented_id = mock_event.id + 1
        response.should redirect_to event_path({id: auto_incremented_id})
      end
    end

    context 'invalid event params' do
      it 'render new' do
        mock_event = event
        invalid_event_params = event_params mock_event
        invalid_event_params[:title] = 'a' * 256
        post :create, event: invalid_event_params
        response.should render_template :new
      end
    end
  end

  describe 'update' do
    before do
      login! users[1]
    end

    context 'valid input' do
      it 'redirect to event_path' do
        mock_event = event
        put :update, id: mock_event.id, event: event_params(mock_event)
        response.should redirect_to event_path mock_event
      end
    end

    context 'invalid input' do
      it 'shows error message' do
        invalid_event_params = event_params(event)
        invalid_event_params[:title] = 'a' * 256
        put :update, id: event.id, event: invalid_event_params
        flash[:alert].should_not be_nil
      end
    end
  end

  describe 'destroy' do
    before do
      login! users[1]
    end

    context 'valid destroy' do
      it 'shows error message' do
        Event.any_instance.stub(:destroy).and_return false
        delete :destroy, id: event.id
        flash[:alert].should_not be_nil
      end
    end

    context 'invalid destroy' do
      it 'redirect to events_path' do
        delete :destroy, id: event.id
        response.should redirect_to events_path
      end
    end
  end

  # TODO:
  describe 'authenticate_owner!' do
  end
end
