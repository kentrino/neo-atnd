require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'Method: attend?' do
    let(:user) do
      # Adjust array index and record id
      [nil] + User.where(id: 1..20)
    end

    let(:event) do
      Event.find_by(id: 1)
    end

    context 'users(id: 1..9) attend' do
      it 'should return true' do
        event.attend?(user[1]).should eq true
      end
    end

    context 'users(id: 10..20) does not attend' do
      it 'should return false' do
        event.attend?(user[11]).should eq false
      end
    end
  end

  describe 'Method: present?' do
    let(:user) do
      # Adjust array index and record id
      [nil] + User.where(id: 1..20)
    end

    let(:event) do
      Event.find_by(id: 1)
    end

    context 'users(id: 1..4) present' do
      it 'should return true' do
        event.attend?(user[1]).should eq true
      end
    end

    context 'users(id: 5..9) are not present' do
      it 'should return true' do
        event.present?(user[5]).should eq false
      end
    end

    context 'users(id: 10..20) are not present' do
      it 'should return false' do
        event.present?(user[11]).should eq false
      end
    end
  end
end
