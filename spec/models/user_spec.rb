require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:users) do
    # Adjust array index and record id
    [nil] + User.where(id: 1..20)
  end

  let(:user) do
    create :user
  end

  let(:provider_twitter) do
    'twitter'
  end

  let(:auth) do
    OmniAuth::AuthHash.new(
      provider: provider_twitter,
      uid: user.uid,
      info: {
        name: user.name,
        nickname: user.nickname,
        image: user.image,
        description: user.description
      },
      credentials: {
        token: user.token,
        secret: user.secret
      }
    )
  end

  describe 'self.find_or_create_from_auth' do
    it 'create correct record' do
      user_created = User.find_or_create_from_auth(auth)
      user_created.should have_attributes(
        provider: provider_twitter,
        uid: user.uid,
        description: user.description,
        token: user.token,
        secret: user.secret
      )
    end
  end
end
