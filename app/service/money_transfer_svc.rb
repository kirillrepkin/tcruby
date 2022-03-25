require 'active_record'
require './app/model/user'
require './app/model/account'
require './app/model/transaction'
require './db/db_conn'

module Service

  ActiveRecord::Base.establish_connection(db_config)

  class MoneyTransferService

  end

end