module Anagram
  class Word < Grape::API
    format :json

    desc 'adds a word to the corpus'
    post '/word.json' do
      true
    end
  end
end
