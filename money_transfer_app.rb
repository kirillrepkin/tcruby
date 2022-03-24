require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'

set :json_content_type, :json

namespace '/api/v1' do

  get '/hello' do
    json :hello => 'world'
  end

end