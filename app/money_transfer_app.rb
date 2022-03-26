require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require './app/service/money_transfer_svc'

set :json_content_type, :json

svc = Service::MoneyTransferService.new()

namespace '/api/v1' do

  # 1.	Получение текущего баланса пользователя
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



end