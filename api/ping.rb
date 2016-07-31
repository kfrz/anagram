module Anagram
  class Ping < Grape::API
    format :json
    desc 'returns pong'
    get '/ping.json' do
      Redis.current.set("ping", "pong")
      pong = Redis.current.get("ping")
      { "ping": pong }
    end
  end
end
