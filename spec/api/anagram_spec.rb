require 'spec_helper'

describe Anagram::API do
  include Rack::Test::Methods

  def app
    Anagram::API
  end

  let(:word_list) { ["read", "used", "dues", "east", "eats", "seat"] }

  it 'fetches anagrams for a given word' do
    pending
    get '/anagrams/read.json'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('').to_json
  end

  it 'fetches anagrams with a limit on results' do
    pending
    get '/anagrams/read.json?limit=1'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('').to_json
  end

  it 'deletes a word and all of its anagrams' do
    pending
    delete '/anagrams/read.json'
    expect(last_response.status).to eq(200)
    expect(words).to eq('')
  end

  it 'gets the word with the highest anagram count' do
    pending
    get '/anagrams/top.json'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('').to_json
  end

  it 'gets all anagram groups with given size' do
    pending
    get '/anagrams/4'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('').to_json
  end
end
