module Anagram
  class Anagram < Grape::API
    format :json

    desc 'fetches anagrams for given word'
    get '/anagrams/:word.json' do
      true
    end
  end
end
