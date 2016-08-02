require 'spec_helper'

describe Anagram::API do
  include Rack::Test::Methods

  def app
    Anagram::API
  end

  # Reset the data store
  Redis.current.flushdb

  let(:word_list) { (['read','used','dues','east','eats','seat','actors','costar']) }
  let(:stat_block) {'{"stats":{"word_count":8,"min_length":4,"max_length":6,"median":4,"mean":"4.50"}}'}

  it 'adds a word to the corpus with valid json' do
    post '/api/words', 'words': word_list.to_json
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq(word_list.to_json)
  end

  it 'does not add words that exist already' do
    post '/api/words', 'words': word_list.to_json
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq(word_list.to_json)
  end

  it 'returns an error with invalid json' do
    post '/api/words', 'words': word_list
    expect(last_response.status).to eq(400)
    expect(last_response.body).to eq(('{"error":"words is invalid"}'))
  end

  it 'gets all words' do
    get '/api/words'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq(word_list.sort.to_json)
  end

  it 'returns word count stats' do
    get '/api/words/stats'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq(stat_block)
  end

  it 'deletes a single word from the corpus' do
    delete '/api/words/east'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq((['eats','seat']).to_json)
  end

  it 'deletes all words from the corpus' do
    delete '/api/words'
    expect(last_response.status).to eq(204)
    expect(Redis.current.keys('*').length).to be(0)
  end
end
