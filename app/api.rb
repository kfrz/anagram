module Anagram
  class API < Grape::API
    format :json

    mount ::Anagram::Ping
    mount ::Anagram::Word
    mount ::Anagram::Anagram
  end
end
