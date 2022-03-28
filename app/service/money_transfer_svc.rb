require 'active_record'
require './app/model/user'
require './app/model/account'
require './app/model/transaction'
require './app/model/request'
require './db/db_conn'

module Service

  class MoneyTransferService

    def initialize
      ActiveRecord::Base.establish_connection(db_config)
    end

    def get_account(user_id)
      user = Entity::User.find_user(user_id)
      user.account
    end

    def create_request(sender_id, recipient_id, sum, currency, keyword)
      raise ArgumentError.new("Sender and recipient should be different user") if sender_id == recipient_id
      raise ArgumentError.new("Request can't be created without keyword") if keyword.nil?
      sender = Entity::User.find_user(sender_id)
      raise ArgumentError.new("Sender not fount") if sender.nil?
      recipient = Entity::User.find_user(recipient_id)
      raise ArgumentError.new("Recipient not fount") if sender.nil?
      request = Entity::Request.create(
        sum: sum, currency: currency,
        sender_id: sender.id, recipient_id: recipient.id,
        status: :created, keyword: keyword)
      request.save!
      request
    end

    def accept_request(request_id, keyword)
      request = find_request(request_id)
      raise ArgumentError.new("Wrong keyword") unless request.key? keyword
      request.accept
    end

    def decline_request(request_id, keyword)
      request = find_request(request_id)
      raise ArgumentError.new("Wrong keyword") unless request.key? keyword
      request.decline
    end

    def get_requests_to_user(user_id)
      requests = Entity.Request.find(sender_id: user_id, status: :created)
      requests
    end

    def find_request(request_id)
      request = Entity::Request.find(request_id)
      raise ArgumentError.new("Request not found") if request.nil?
      request
    end

  end

end