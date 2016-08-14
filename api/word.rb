module Anagram
  class Word < Grape::API
    resources :words do
      desc 'adds words to the corpus'
      params do
        requires :words, type: String, desc: 'Words'
      end
      post do
        words = JSON.parse(params[:words])
        Corpus.current.add_words(words)
      end

      desc 'adds a text file of words to the dictionary'
      params do
        requires :dictionary, type: File, desc: 'file'
      end
      post 'upload' do
        Corpus.current.add_dict(params[:dictionary])
      end

      desc 'returns all words in alphabetical order'
      get do
        Corpus.current.all_words
      end

      desc 'deletes a single word from the corpus'
      delete '/:word' do
        Corpus.current.delete(params[:word])
      end

      desc 'deletes all words from the corpus'
      delete '' do
        if Corpus.current.clean
          body false
        end
      end

      desc 'return stats about the corpus'
      # params do
      #   optional :median, :mean, :count, :length, type: Boolean, desc: 'Options'
      get '/stats' do
        stats = Stats.new(Corpus.current)
        stats.stats
      end
    end
  end
end
