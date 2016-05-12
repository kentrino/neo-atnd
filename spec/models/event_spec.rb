require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) do
    # Adjust array index and record id
    [nil] + User.where(id: 1..20)
  end

  let(:event) do
    Event.find_by(id: 1)
  end

  describe :owner? do
    context 'user: event owner' do
      it 'should return true' do
        event.owner?(user[1]).should eq true
      end
    end

    context 'user: not event owner' do
      it 'should return true' do
        event.owner?(user[2]).should eq false
      end
    end
  end

  describe :attend? do
    context 'users(id: 1..4) present' do
      it 'should return true' do
        event.attend?(user[1]).should eq true
        event.attend?(user[2]).should eq true
        event.attend?(user[3]).should eq true
        event.attend?(user[4]).should eq true
      end
    end

    context 'users(id: 5..9) are absent' do
      it 'should return true' do
        event.attend?(user[5]).should eq false
        event.attend?(user[6]).should eq false
        event.attend?(user[7]).should eq false
        event.attend?(user[8]).should eq false
        event.attend?(user[9]).should eq false
      end
    end

    context 'users(id: 10..20) are not present' do
      it 'should return false' do
        event.attend?(user[11]).should eq false
      end
    end
  end

  describe :attendees do
    it 'return correct attendees' do
      event.attendees.map(&:id).sort.should eq [1, 2, 3, 4]
    end
  end

  describe :absentees do
    it 'return correct absentees' do
      event.absentees.map(&:id).sort.should eq [5, 6, 7, 8, 9]
    end
  end
end
