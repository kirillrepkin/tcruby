require './app/model/user'
require './app/model/account'
require './app/model/transaction'

users = [
  [1, "ivan01.ivanov", "Ivan", "Ivanov"],
  [2, "petrX1.petrov", "Petr", "Petrov"]
]

accounts = [
  [1, "NL07INGB5373380466", 1, 10500, 'EUR'],
  [2, "PL02109024026216714137852653", 2, 10500, 'EUR']
]

transactions = [
  [1, 'ok', 10500, 'EUR', 1],
  [2, 'ok', 10500, 'EUR', 2]
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
  Entity::Transaction.create(id: id, status: status, sum: sum, account_id: account_id)
end

puts 'Done.'