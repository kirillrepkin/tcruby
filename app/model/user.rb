require 'active_record'

module Entity
  class User < ActiveRecord::Base

    has_one :account

    def self.find_user(user_identity)
      user = Entity::User.find_by(id: user_identity)
      user = Entity::User.find_by(username: user_identity) if user.nil?
      raise ArgumentError.new("User not found") if user.nil?
      user
    end

  end
end
