require 'spec_helper'

describe Anagram::API do
  include Rack::Test::Methods

  def app
    Anagram::API
  end

 let(:word_list) { ["read", "used", "dues", "east", "eats", "seat"] }

 it 'adds a word to the corpus' do
    pending
    post '/words', word_list.to_json
    expect(last_response.status).to eq(201)
    expect(words).to eq('read')
  end

  it 'gets all words' do
    pending
    get '/words'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq(['one'].to_json)
  end

  it 'deletes a single word from the corpus' do
    pending
    delete '/words/read.json'
    expect(last_response.status).to eq(200)
  end

  it 'deletes all words from the corpus' do
    pending
    delete '/words.json'
    expect(last_response.status).to eq(204)
  end

  it 'returns word count stats' do
    pending
    get '/words/stats.json'
    expect(last_response.status).to eq(200)
  end
end
