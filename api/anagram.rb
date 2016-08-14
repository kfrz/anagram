module Anagram
  class Anagram < Grape::API
    resources :anagrams do
      format :json

      desc 'returns all anagram groups'
      get do
        Corpus.current.get_anagrams
      end

      desc 'fetches anagrams for given word'
      params do
        requires :word, type: String, desc: 'Word to lookup'
        optional :limit, type: Integer, desc: 'Limit number of results'
      end
      get '/:word' do
        limit = params[:limit] ? params[:limit] - 1 : 100
        Corpus.current.get_anagrams(params[:word], limit)
      end

      desc 'deletes a word and all of its anagrams'
      delete '/:word' do
        Corpus.current.delete(params[:word], true)
      end
    end
  end
end
