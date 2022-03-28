require './app/money_transfer_app'
require 'test/unit'
require 'rack/test'
require 'securerandom'

class MoneyTransferAppTest_Transfer <Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  SENDER = ["ivan01.ivanov", "4fe31bba-ad0b-11ec-b909-0242ac120002"]
  RECIPIENT = ["petrX1.petrov", "4fe31f48-ad0b-11ec-b909-0242ac120002"]
  SUM = 100
  CURRENCY = 'EUR'

  def test_money_transfer_happy_path
    put '/api/v1/transfer/' + SENDER[0] + '/' + RECIPIENT[0], params = {:sum => SUM, :currency => CURRENCY}
    assert last_response.ok?
    json = JSON.parse(last_response.body)
    assert json['sender_id'] == SENDER[1]
    assert json['recipient_id'] == RECIPIENT[1]
    assert json['sum'] == SUM
    assert json['currency'] == CURRENCY
  end

  def test_money_transfer_zero_sum
    put '/api/v1/transfer/' + SENDER[0] + '/' + RECIPIENT[0], params = {:sum => 0, :currency => CURRENCY}
    assert last_response.status == 404
    json = JSON.parse(last_response.body)
    assert json['class'] == 'ArgumentError'
    assert json['message'].include? 'sum'
  end

  def test_money_transfer_unknown_currency
    put '/api/v1/transfer/' + SENDER[0] + '/' + RECIPIENT[0], params = {:sum => SUM, :currency => 'USD'}
    assert last_response.status == 404
    json = JSON.parse(last_response.body)
    assert json['class'] == 'ArgumentError'
    assert json['message'].include? "Currency 'USD'"
  end

end