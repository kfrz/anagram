module Anagram
  class Word < Grape::API
    helpers do
      def all_words
        keys = Redis.current.keys('*')
        words = []
        keys.each do |key|
          words.push(Redis.current.smembers(key))
        end
        words.zip.flatten.compact.sort
      end
    end

    resources :words do
      format :json
      desc 'adds a word to the corpus'
      params do
        requires :words, type: String, desc: 'Words'
      end
      post do
        words = JSON.parse(params[:words])
        words.each do |word|
         key = word.split('').sort.join
         Redis.current.sadd(key, word)
         Redis.current.smembers(key)
        end
      end

      desc 'returns all words in alphabetical order'
      get do
        all_words
      end

      desc 'deletes a single word from the corpus'
      delete '/:word' do
        word = params[:word]
        key = word.split('').sort.join
        Redis.current.srem(key, word)
        Redis.current.smembers(key).sort
      end

      desc 'deletes all words from the corpus'
      delete '' do
        if Redis.current.flushdb
          body false
        end
        # TODO Add error handling
      end

     desc 'returns word count statistics'
      get '/stats' do
        @word_count = all_words.length
        { stats: {count: @word_count} }
      end
    end
  end
end
