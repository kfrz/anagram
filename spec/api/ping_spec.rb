require 'spec_helper'

describe Anagram::API do
  include Rack::Test::Methods

  def app
    Anagram::API
  end

  it 'ping' do
    get '/ping.json'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({ ping: 'pong' }.to_json)
    Redis.current.del('ping')
  end
end
