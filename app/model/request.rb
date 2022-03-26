require 'active_record'

module Entity
  class Request < ActiveRecord::Base
    enum status: [:created, :declined, :completed]
  end
end