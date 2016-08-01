module Anagram
  class API < Grape::API
    format :json

    mount ::Anagram::Ping
  end
end
