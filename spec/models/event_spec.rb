require 'rails_helper'

RSpec.describe Event, type: :model do
  describe :owner? do
    let(:user) { create :user }
    let(:event) { create :event, user: user }
    let(:non_owner_user) { create :user }

    context 'user: event owner' do
      it 'should return true' do
        event.owner?(user).should eq true
      end
    end

    context 'user: not event owner' do
      it 'should return true' do
        event.owner?(non_owner_user).should eq false
      end
    end
  end

  describe :attend? do
    let(:users) do
      create_list :user, 4
    end

    let(:absent_users) do
      create_list :user, 4
    end

    let(:other_users) do
      create_list :user, 4
    end

    let(:event) do
      create :event, attendees: users, absentees: absent_users
    end

    context 'users present' do
      it 'should return true' do
        event.attend?(users[0]).should eq true
        event.attend?(users[3]).should eq true
      end
    end

    context 'users are absent' do
      it 'should return false' do
        event.attend?(absent_users[0]).should eq false
        event.attend?(absent_users[3]).should eq false
      end
    end

    context 'other users are not present' do
      it 'should return false' do
        event.attend?(other_users[0]).should eq false
        event.attend?(other_users[3]).should eq false
      end
    end
  end
end
