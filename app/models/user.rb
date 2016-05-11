# frozen_string_literal: true

class User < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  # Create User record from a VALID auth object
  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]

    find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = auth[:info][:name]
      user.nickname = auth[:info][:nickname]
      user.image = auth[:info][:image]
      user.description = auth[:info][:description]

      user.token = auth[:credentials][:token]
      user.secret = auth[:credentials][:secret]
    end
  end

  # Enable absent attribute
  attr_accessor :absent
end
