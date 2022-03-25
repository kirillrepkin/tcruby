require 'active_record'

module Entity
  class User < ActiveRecord::Base
    has_one :account
  end
end
