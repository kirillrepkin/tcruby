require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require './app/service/money_transfer_svc'

set :json_content_type, :json

namespace '/api/v1' do

  get '/hello' do
    json :hello => 'world'
  end

  get '/users' do
    require './app/model/user'
    json Entity::User.all
  end

end