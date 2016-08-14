require 'spec_helper'

describe Anagram::Corpus do
  include Rack::Test::Methods

  let(:corpus) { Anagram::Corpus.new }

  it 'adds a word to the corpus' do
    corpus.add_words(['used'])
    expect(corpus.all_words).to eq(['used'])
    corpus.clean
  end

  it 'adds many words to the corpus' do
    corpus.add_words(['seat','east','west','farmer'])
    expect(corpus.all_words).to eq(['east','farmer','seat','west'])
    corpus.clean
  end

  it 'removes a word from the corpus' do
    corpus.add_words(['seat','east'])
    expect(corpus.all_words).to eq(['east','seat'])
    corpus.delete('east')
    expect(corpus.all_words).to eq(['seat'])
    corpus.clean
  end

  it 'does not add words that exist already' do
    corpus.add_words(['seat','east'])
    expect(corpus.all_words).to eq(['east','seat'])
    corpus.add_words(['seat'])
    expect(corpus.all_words).to eq(['east','seat'])
    corpus.clean
  end
end
