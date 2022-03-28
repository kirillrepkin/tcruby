require './app/money_transfer_app'
require 'test/unit'
require 'rack/test'

class MoneyTransferAppTest_Transfer <Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  SENDER = ["ivan01.ivanov", "4fe31bba-ad0b-11ec-b909-0242ac120002"]
  RECIPIENT = ["petrX1.petrov", "4fe31f48-ad0b-11ec-b909-0242ac120002"]
  SUM = 500
  CURRENCY = 'EUR'
  KEYWORD = SecureRandom.uuid

  def create_request(sender_id, recipient_id, sum, currency, keyword)
    put '/api/v1/request/' + sender_id + '/' + recipient_id, params = {
      :sum => sum, :currency => currency, :keyword => keyword}
    assert last_response.ok?
    json = JSON.parse(last_response.body)
    request_id = json['id']
    assert json['sender_id'] == SENDER[1]
    assert json['recipient_id'] == RECIPIENT[1]
    assert json['sum'] == SUM
    assert json['currency'] == CURRENCY
    request_id
  end

  def get_user_balance(user_id)
    get '/api/v1/user/' + user_id + '/balance'
    assert last_response.ok?
    json = JSON.parse(last_response.body)
    assert json['currency'] == CURRENCY
    json['sum']
  end

  def accept_request_happy_path(request_id, keyword)
    post '/api/v1/request/' + request_id, params = {:keyword => keyword}
    assert last_response.ok?
    json = JSON.parse(last_response.body)
    assert json['id'] == request_id
  end

  def not_acceptable_state_of_request(request_id, keyword)
    post '/api/v1/request/' + request_id, params = {:keyword => keyword}
    assert last_response.status == 404
    json = JSON.parse(last_response.body)
    assert json['class'] == 'ArgumentError'
  end

  def not_declinable_state_of_request(request_id, keyword)
    post '/api/v1/request/' + request_id, params = {:keyword => keyword}
    assert last_response.status == 404
    json = JSON.parse(last_response.body)
    assert json['class'] == 'ArgumentError'
  end

  def accept_request_wrong_keyword(request_id, keyword)
    post '/api/v1/request/' + request_id, params = {:keyword => keyword}
    assert last_response.status == 404
    json = JSON.parse(last_response.body)
    assert json['class'] == 'ArgumentError'
    assert json['message'] == 'Wrong keyword'
  end

  def decline_request_happy_path(request_id, keyword)
    delete '/api/v1/request/' + request_id, params = {:keyword => keyword}
    assert last_response.ok?
    json = JSON.parse(last_response.body)
    assert json['id'] == request_id
  end

  def decline_request_wrong_keyword(request_id, keyword)
    delete '/api/v1/request/' + request_id, params = {:keyword => keyword}
    assert last_response.status == 404
    json = JSON.parse(last_response.body)
    assert json['class'] == 'ArgumentError'
    assert json['message'] == 'Wrong keyword'
  end

  def test_create_request_and_accept
    request_id = create_request(SENDER[0], RECIPIENT[0], SUM, CURRENCY, KEYWORD)
    sender_balance_before = get_user_balance SENDER[0]
    recipient_balance_before = get_user_balance RECIPIENT[0]
    accept_request_wrong_keyword(request_id, 'wrong_keyword_here')
    accept_request_happy_path(request_id, KEYWORD)
    sender_balance_after = get_user_balance SENDER[0]
    recipient_balance_after = get_user_balance RECIPIENT[0]
    assert sender_balance_after + SUM == sender_balance_before
    assert recipient_balance_after - SUM == recipient_balance_before
    not_acceptable_state_of_request request_id, KEYWORD
  end

  def test_create_request_and_decline
    request_id = create_request(SENDER[0], RECIPIENT[0], SUM, CURRENCY, KEYWORD)
    sender_balance_before = get_user_balance SENDER[0]
    recipient_balance_before = get_user_balance RECIPIENT[0]
    decline_request_wrong_keyword(request_id, 'wrong_keyword_here')
    decline_request_happy_path(request_id, KEYWORD)
    sender_balance_after = get_user_balance SENDER[0]
    recipient_balance_after = get_user_balance RECIPIENT[0]
    assert sender_balance_after == sender_balance_before
    assert recipient_balance_after == recipient_balance_before
    not_declinable_state_of_request request_id, KEYWORD
  end

end
