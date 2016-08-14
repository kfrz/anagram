require 'spec_helper'

describe Anagram::Stats do
  include Rack::Test::Methods

  let(:corpus) { Anagram::Corpus.new }
  let(:stats) { Anagram::Stats.new(corpus).stats }
  let(:word_list) { ['word', 'sued', 'dues'] }
  before(:each) {
    corpus.add_words(word_list)
  }

  it 'counts the words in the corpus' do
    expect(stats[:stats][:word_count]).to eq(3)
  end

  it 'returns the min length of word' do
    expect(stats[:stats][:min_length]).to eq(4)
  end

  it 'returns the max length of word' do
    expect(stats[:stats][:max_length]).to eq(4)
  end

  it 'returns the median word length' do
    expect(stats[:stats][:median]).to eq(4)
  end

  it 'returns the mean word length' do
    expect(stats[:stats][:mean]).to eq('4.00')
    corpus.clean
  end
end
