module Anagram
  class API < Grape::API
    format :json
    prefix 'api'

    mount ::Anagram::Ping
    mount ::Anagram::Word
    mount ::Anagram::Anagram
  end
end
