require 'active_record'

module Entity
  class Transaction < ActiveRecord::Base

    belongs_to :account
    enum :status, {:created => 'created', :failed => 'failed', :completed => 'completed'}, default: :created

    def self.transactions_for(sender, recipient, sum, currency)
      snd_tran = Entity::Transaction.create(
        account: sender.account, sum: -1 * sum, currency: currency)
      rcpt_tran = Entity::Transaction.create(
        account: recipient.account, sum: sum, currency: currency)
      [snd_tran, rcpt_tran]
    end

  end
end