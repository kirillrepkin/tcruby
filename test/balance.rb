require './app/money_transfer_app'
require 'test/unit'
require 'rack/test'

class MoneyTransferAppTest_Balance <Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  USER = ["ivan01.ivanov", "4fe31bba-ad0b-11ec-b909-0242ac120002"]

  # 1.	Получение текущего баланса пользователя
  def test_get_user_balance_n1
    get '/api/v1/user/' + USER[0] + '/balance'
    assert last_response.ok?
    json = JSON.parse(last_response.body)
    assert json['user_id'] == USER[1]
    assert json['sum'] > 0
  end

  # 1.	Получение текущего баланса пользователя
  def test_get_user_balance_n2
    username = 'some_user_here'
    get '/api/v1/user/' + username + '/balance'
    assert last_response.status == 404
    json = JSON.parse(last_response.body)
    assert json['class'] == 'ArgumentError'
    assert json['message'] == 'User not found'
  end

end