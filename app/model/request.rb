require 'active_record'

module Entity
  class Request < ActiveRecord::Base

    enum status: [:created, :declined, :completed]

    attribute :sender_id
    attribute :recipient_id
    attribute :keyword

    def transactions
      @transactions = Entity::Transaction.transactions_for self.sender, self.recipient, self.sum, self.currency if @transactions.nil?
      @transactions
    end

    def update_transactions(status)
      transactions.each do |tran|
        tran.status = status
        tran.save
      end
    end

    def sender
      @sender_user = Entity::User.find(sender_id) if @sender_user.nil?
      @sender_user
    end

    def recipient
      @recipient_user = Entity::User.find(recipient_id) if @recipient_user.nil?
      @recipient_user
    end

    def decline
      self.status = :declined
      self.save
    end

    def accept
      self.make_transfer
      self.status = :completed
      self.save
    end

    def key?(keyword)
      self.keyword == keyword
    end

    private

    def make_transfer
      Entity::Account.transaction do
        update_transactions :created
        sender.account.lock!
        recipient.account.lock!
        raise Exception.new("Not enough funds in the account of sender") if sender.account.sum < self.sum
        sender.account.sum -= self.sum
        sender.account.save!
        recipient.account.sum += self.sum
        recipient.account.save!
        update_transactions :completed
      end
    end

  end
end