require './app/model/user'
require './app/model/account'
require './app/model/transaction'

users = [
  ["4fe31bba-ad0b-11ec-b909-0242ac120002", "ivan01.ivanov", "Ivan", "Ivanov"],
  ["4fe31f48-ad0b-11ec-b909-0242ac120002", "petrX1.petrov", "Petr", "Petrov"]
]

accounts = [
  ["4fe32114-ad0b-11ec-b909-0242ac120002", "NL07INGB5373380466", "4fe31bba-ad0b-11ec-b909-0242ac120002", 10500, 'EUR'],
  ["4fe3259c-ad0b-11ec-b909-0242ac120002", "PL02109024026216714137852653", "4fe31f48-ad0b-11ec-b909-0242ac120002", 10500, 'EUR']
]

transactions = [
  ["4fe32790-ad0b-11ec-b909-0242ac120002", :completed, 10500, 'EUR', "4fe32114-ad0b-11ec-b909-0242ac120002"],
  ["4fe32952-ad0b-11ec-b909-0242ac120002", :completed, 10500, 'EUR', "4fe3259c-ad0b-11ec-b909-0242ac120002"]
]

puts 'Clean up...'
Entity::Transaction.delete_all
Entity::Account.delete_all
Entity::User.delete_all

puts 'Creating users...'
users.each do |id, username, first_name, last_name|
  Entity::User.create(id: id, username: username, first_name: first_name, last_name: last_name)
end

puts 'Creating accounts...'
accounts.each do |id, acc_number, user_id, sum, currency|
  Entity::Account.create(id: id, acc_number: acc_number, user_id: user_id, sum: sum, currency: currency)
end

puts 'Creating transactions...'
transactions.each do |id, status, sum, currency, account_id|
  Entity::Transaction.create(id: id, status: status, sum: sum, currency: currency, account_id: account_id)
end

puts 'Done.'