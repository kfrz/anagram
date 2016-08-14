require 'pry'
module Anagram
  class Stats
    attr_accessor :words

    def initialize(corpus)
      @words = corpus.all_words
    end

    def median_word_length
      arr = word_lengths
      center = arr.length/2
      arr.length.even? ? (arr[center] + arr[center+1])/2 : arr[center]
    end

    def mean_word_length
      arr = word_lengths
      '%.2f' % (arr.inject(:+).to_f / arr.length)
    end

    def stats
            { stats: {
          word_count: @words.length,
          min_length: min_word_length,
          max_length: max_word_length,
          median: median_word_length,
          mean: mean_word_length
        }}
    end

    def min_word_length
      @words.min_by{ |x| x.size  }.size
    end

    def max_word_length
      @words.max_by{ |x| x.size  }.size
    end

    def word_lengths
      @words.map { |x| x.length }
    end
  end
end
