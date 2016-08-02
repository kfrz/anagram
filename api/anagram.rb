module Anagram
  class Anagram < Grape::API
    helpers do
      def key_gen(word)
        key = word.split('').sort.join
      end
    end

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
        # Unless? Use sexier loop here
        if params[:limit]
          limit = params[:limit] - 1
        else limit = 100
        end
        @res = Redis.current.smembers(key).sort[0..limit]
        { anagrams: @res }
      end

      desc 'deletes a word and all of its anagrams'
      delete '/:word' do
        word = params[:word]
        key = key_gen(word)
        Redis.current.del(key)
      end
     end
    end
  end
end
