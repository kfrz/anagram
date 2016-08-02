require 'spec_helper'

describe Anagram::API do
  include Rack::Test::Methods

  def app
    Anagram::API
  end

  # Reset the data store
  Redis.current.flushdb

  let(:word_list) { (["read", "used", "dues", "east", "eats", "seat"]).to_json }

  before do
    post '/words.json', 'words': word_list
  end

  it 'fetches anagrams for a given word' do
    # returns anagrams for this word but doesnt check if it's extant
    # it should add to the set
    get '/anagrams/sued'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq((['dues', 'used']).to_json)
  end

  it 'fetches anagrams with a limit on results' do
    get '/anagrams/desu.json?limit=1'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq((['dues']).to_json)
  end

  it 'deletes a word and all of its anagrams' do
    delete '/anagrams/used'
    expect(last_response.status).to eq(200)
    expect(Redis.current.smembers('desu').length).to eq(0)
  end

  # it 'gets the word with the highest anagram count' do
  #   pending
  #   get '/anagrams/top.json'
  #   expect(last_response.status).to eq(200)
  #   expect(last_response.body).to eq('')
  # end

  # it 'gets all anagram groups with given size' do
  #   pending
  #   get '/anagrams/4'
  #   expect(last_response.status).to eq(200)
  #   expect(last_response.body).to eq('')
  # end
end
