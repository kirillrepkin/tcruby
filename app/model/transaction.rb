require 'active_record'

module Entity
  class Transaction < ActiveRecord::Base
    belongs_to :account
    enum status: [:created, :failed, :completed]
  end
end