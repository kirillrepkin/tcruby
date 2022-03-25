require 'active_record'
require './app/model/user'
require './app/model/account'
require './app/model/transaction'
require './db/db_conn'

module Service

  ActiveRecord::Base.establish_connection(db_config)

  class MoneyTransferService

    def find_user(user_identity)
      Entity::User.find_by(username: user_identity)
    end

  end

end