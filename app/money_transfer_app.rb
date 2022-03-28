require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require './app/service/money_transfer_svc'
require 'securerandom'
require './app/schema'

set :json_content_type, :json
set :show_exceptions, false

svc = Service::MoneyTransferService.new()

namespace '/api/v1' do

  # 1. Получение текущего баланса пользователя
  get '/user/:user_id/balance' do |user_id|
    account = svc.get_account user_id
    json Schema::V1::Balance.new(account).to_json
  end

  # 2. Перевод денег на счёт другого пользователя
  put '/transfer/:sender_id/:recipient_id' do |sender_id, recipient_id|
    sum, currency = get_params :sum, :currency
    keyword = SecureRandom.uuid
    request = svc.create_request(sender_id, recipient_id, sum, currency, keyword)
    svc.accept_request(request.id, request.keyword)
    json Schema::V1::Request.new(request).to_json
  end

  # 3. Запрос пополнения со счёта другого пользователя
  put '/request/:sender_id/:recipient_id' do |sender_id, recipient_id|
    sum, currency, keyword = get_params :sum, :currency, :keyword
    request = svc.create_request(sender_id, recipient_id, sum, currency, keyword)
    json Schema::V1::Request.new(request).to_json
  end

  # 4. Акцепт на перевод денег со стороны пользователя в случае запроса на перевод
  post '/request/:request_id' do |request_id|
    keyword = get_params(:keyword)[0]
    svc.accept_request request_id, keyword
    request = svc.find_request request_id
    json Schema::V1::Request.new(request).to_json
  end

  # Отказ в запросе на перевод денег со стороны пользователя
  delete '/request/:request_id' do |request_id|
    keyword = get_params(:keyword)[0]
    svc.decline_request request_id, keyword
    request = svc.find_request request_id
    json Schema::V1::Request.new(request).to_json
  end

  error do |e|
    if e.class == ArgumentError
      status 404
    else
      status 500
    end
    json Schema::V1::Error.new(e).to_json
  end

  error 404 do
    body ''
  end

  def currencies
    ['EUR']
  end

  def get_params *args
    args.map { |p| send("param_check_" + p.to_s) }
  end

  def param_check_sum
    value = params['sum']
    raise ArgumentError.new("Parameter 'sum' is empty") if value.nil? or value.empty?
    raise ArgumentError.new("Parameter 'sum' is incorrect") if Float(value) <= 0
    value
  end

  def param_check_currency
    value = params['currency']
    raise ArgumentError.new("Parameter 'currency' is empty") if value.nil? or value.empty?
    raise ArgumentError.new("Currency '" + value + "' is not supported yet") unless currencies.include? value
    value
  end

  def param_check_keyword
    value = params['keyword']
    raise ArgumentError.new("Parameter 'keyword' is empty") if value.nil? or value.empty?
    value
  end

  get '/requests' do
    json Entity::Request.all
  end

end