require 'helpers/stats'
module Anagram
  class Word < Grape::API
    resources :words do
      format :json

      desc 'adds a word to the corpus'
      params do
        requires :words, type: String, desc: 'Words'
      end
      post do
        words = JSON.parse(params[:words])
        words.each do |word|
          add_word(key_gen(word), word)
        end
      end

      desc 'returns all words in alphabetical order'
      get do
        all_words
      end

      desc 'deletes a single word from the corpus'
      delete '/:word' do
        word = params[:word]
        Redis.current.srem(key_gen(word), word)
        Redis.current.smembers(key_gen(word)).sort
      end

      desc 'deletes all words from the corpus'
      delete '' do
        if Redis.current.flushdb
          body false
        end
      end

      desc 'returns word count statistics'
      get '/stats' do
        corpus = all_words
        @word_count = corpus.size
        @min_length = corpus.min_by{ |x| x.size }.size
        @max_length = corpus.max_by{ |x| x.size }.size
        @median = median_word_length
        @mean = mean_word_length
        { stats: {
            word_count: @word_count,
            min_length: @min_length,
            max_length: @max_length,
            median: @median,
            mean: @mean
          } }
      end

    end
  end
end
