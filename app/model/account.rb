require 'active_record'

module Entity
  class Account < ActiveRecord::Base
    has_many :transactions
    belongs_to :user
  end
end