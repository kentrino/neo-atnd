require 'rails_helper'

describe EventsHelper do
  let(:users) do
    create_list :user, 3
  end

  describe 'get_user_links' do
    it 'returns correct value' do
      get_user_links(users).should match(%r{users/#{users[0].id}})
      get_user_links(users).should match(%r{users/#{users[1].id}})
      get_user_links(users).should match(%r{users/#{users[2].id}})
      get_user_links(users).should match(/#{users[0].name}/)
      get_user_links(users).should match(/#{users[1].name}/)
      get_user_links(users).should match(/#{users[2].name}/)
    end
  end

  describe 'edit_action' do
    it 'should return correct value when action is edit' do
      allow(controller).to receive(:action_name).and_return 'edit'
      edit_action.should eq true
    end

    it 'should return correct value when action is not edit' do
      allow(controller).to receive(:action_name).and_return 'hoge'
      edit_action.should eq false
    end
  end
end
