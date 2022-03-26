require 'active_record'
require './app/model/user'
require './app/model/account'
require './app/model/transaction'
require '../../app/model/request'
require './db/db_conn'

module Service

  ActiveRecord::Base.establish_connection(db_config)

  class MoneyTransferService

    def find_user(user_identity)
      user = User.find(user_identity)
      user = Entity::User.find_by(username: user_identity) if user.nil?
      raise ArgumentError.new("User not found") if user.nil?
      user
    end

    def create_request(sender_id, recipient_id, sum, currency = 'EUR')
      raise ArgumentError.new("Sender and recipient should be different user") if sender_id == recipient_id
      sender = find_user(sender_id)
      recipient = find_user(recipient_id)
      request = Entity::Request.create(
        sum: sum, currency: currency, sender: sender, recipient: recipient, status: :created)
      request.save!
      request
    end

    def accept_request(request_id, keyword)
      request = find_request(request_id)
      raise ArgumentError.new("Wrong keyword") unless request.keyword == keyword
      transactions = request_to_transactions(request)
      transactions.each do |t|
        t.status = :created
        t.save
      end
      Entity::Account.transaction do
        request.sender.account.lock!
        request.recipient.account.lock!
        request.sender.account.sum -= request.sum
        request.sender.account.save!
        request.recipient.account.sum += request.sum
        request.recipient.account.save!
      end
      transactions.each do |t|
        t.status = :completed
        t.save
      end
      request.status = :completed
      request.save
    end

    def decline_request(request_id)
      request = find_request(request_id)
      request.status = :declined
      request.save
    end

    def get_requests_to_user(user_id)
      requests = Entity.Request.find(sender_id: user_id, status: :created)
      requests
    end

    private

    def request_to_transactions(request)
      snd_tran = Entity::Transaction.create(
        account: request.sender.account, sum: -1 * request.sum, currency: request.currency)
      rcpt_tran = Entity::Transaction.create(
        account: request.recipient.account, sum: request.sum, currency: request.currency)
      [snd_tran, rcpt_tran]
    end

    def find_request(request_id)
      request = Entity::Request.find(request_id)
      raise ArgumentError.new("Request not found") if request.nil?
      request
    end

  end

end