require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require './app/service/money_transfer_svc'

set :json_content_type, :json

svc = Service::MoneyTransferService.new()

namespace '/api/v1' do

  # 1. Получение текущего баланса пользователя
  get '/user/:user_id/balance' do |user_id|
    user = svc.find_user(user_id)
    if user.nil?
      status 404
      body ''
    else
      result = {
        'user_id' => user_id,
        'balance' => user.account.sum,
        'currency' => user.account.currency }
      json result
    end
  end

  # 2. Перевод денег на счёт другого пользователя
  post '/transfer/:sender_id/:recipient_id' do |sender_id, recipient_id|
    sum = params['sum']
    currency = params['currency']
  end

  # 3. Запрос пополнения со счёта другого пользователя
  post '/request/:sender_id/:recipient_id' do |sender_id, recipient_id|
    sum = params['sum']
    currency = params['currency']
    keyword = params['keyword']
  end

  # 4. Акцепт на перевод денег со стороны пользователя в случае запроса на перевод
  put '/request/:request_id' do |request_id|
    keyword = params['keyword']
  end

  delete '/request/:request_id' do |request_id|
    keyword = params['keyword']
  end

end