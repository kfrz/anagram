module Anagram
  class API < Grape::API
    helpers do
      def add_word(key, word)
        Redis.current.sadd(key, word)
        Redis.current.smembers(key)
      end

      def all_words
        keys = Redis.current.keys('*')
        words = []
        keys.each do |key|
          words.push(Redis.current.smembers(key))
        end
        words.zip.flatten.compact.sort
      end

      def key_gen(word)
        word.split('').sort.join
      end

      def word_lengths
        # maps the length of words to array
        corpus = all_words
        corpus.map { |x| x.length }
      end

      def median_word_length
        arr = word_lengths
        center = arr.length/2
        # if even we have to split the difference
        # if not, we have a perfect median!
        res = arr.length.even? ? (arr[center] + arr[center+1])/2 : arr[center]
      end

      def mean_word_length
        arr = word_lengths
        size = arr.length
        # two methods to deliver rounded mean, same logic. I prefer the second.
        # res = '%2f' % (arr.inject { |sum, el| sum + el }.to_f / size)
        res = '%.2f' % (arr.inject(:+).to_f / size)
      end
    end
  end
end
