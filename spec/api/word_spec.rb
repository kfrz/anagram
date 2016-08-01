require 'spec_helper'

describe Anagram::API do
  include Rack::Test::Methods

  def app
    Anagram::API
  end

  # Reset the data store
  Redis.current.flushdb

  let(:word_list) { ['read','used','dues','east','eats','seat'] }

  it 'adds a word to the corpus' do
    post '/words.json', 'words': word_list
    expect(last_response.status).to eq(201)
    expect(JSON.parse(last_response.body)).to eq(['read','used','dues','east','eats','seat'])
  end

  it 'does not add words that exist already' do
    post '/words.json', 'words': word_list
    expect(last_response.status).to eq(201)
    expect(JSON.parse(last_response.body)).to eq(['read','used','dues','east','eats','seat'])
  end

  it 'gets all words' do
    get '/words.json'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq(['dues','east','eats','read','seat','used'])
  end

  it 'returns word count stats' do
    get '/words/stats.json'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq('{"stats":{"count":6}}')
  end

  it 'deletes a single word from the corpus' do
    delete '/words/east'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq(['eats','seat'])
  end

  it 'deletes all words from the corpus' do
    delete '/words.json'
    expect(last_response.status).to eq(204)
    expect(Redis.current.keys('*').length).to be(0)
  end
end
