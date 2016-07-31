module Anagram
  class API < Grape::API
    prefix 'api'
    format :json

    mount ::Anagram::Ping
  end
end
