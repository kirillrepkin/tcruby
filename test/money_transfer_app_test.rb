require './app/money_transfer_app'
require 'test/unit'
require 'rack/test'

class MoneyTransferAppTest <Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_get_user_balance_n1
    username = "ivan01.ivanov"
    get '/api/v1/user/' + username + '/balance'
    assert last_response.ok?
    json = JSON.parse(last_response.body)
    assert json['user_id'] == username
    assert json['balance'] > 0
  end

  def test_get_user_balance_n2
    username = 'some_user_here'
    get '/api/v1/user/' + username + '/balance'
    assert last_response.status == 404
    assert last_response.body.empty?
  end

end