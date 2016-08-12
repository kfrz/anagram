require 'helpers/word_helpers.rb'
module Anagram
  class Anagram < Grape::API
    resources :anagrams do
      format :json

      desc 'returns all anagram groups'
      get do
        Redis.current.keys('*')
      end

      desc 'fetches anagrams for given word'
      params do
        requires :word, type: String, desc: 'Word to lookup'
        optional :limit, type: Integer, desc: 'Limit number of results'
      end
      get '/:word' do
        key = key_gen(params[:word])
        is_limit = params[:limit]
        # if there's a limit passed, use it else use default 100
        limit = is_limit ? (is_limit - 1) : 100
        @res = Redis.current.smembers(key).sort[0..limit]
        { anagrams: @res }
      end

      desc 'deletes a word and all of its anagrams'
      delete '/:word' do
        word = params[:word]
        key = key_gen(word)
        @res = Redis.current.del(key)
      end
    end
  end
end
