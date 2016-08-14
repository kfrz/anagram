module Anagram
  class Corpus
    attr_accessor :all_words, :all_keys, :current

    def self.initialize
      @all_keys = all_keys
      @all_words = all_words
    end

    def self.current
      @current || Corpus.new
    end

    def add_dict(file)
      words = File.readlines(file[:tempfile].path).map
      add_words(words)
    end

    def add_words(words)
      words.each do |word|
        Redis.current.sadd(key_gen(word), word.strip.downcase)
      end
      Corpus.current.all_words
    end

    def all_keys
      Redis.current.keys('*')
    end

    def all_words
      words = []
      all_keys.each do |key|
        words.push(Redis.current.smembers(key))
      end
      words.flatten.sort
    end

    def clean
      Redis.current.flushdb
    end

    def delete(word, and_anagrams=false)
      if and_anagrams
        Redis.current.del(key_gen(word))
      else
        Redis.current.srem(key_gen(word), word)
      end
    end

    def get_anagrams(word, limit)
      res = Redis.current.smembers(key_gen(word)).sort[0..limit]
      { anagrams: res }
    end

    def key_gen(word)
      word.split('').sort.join
    end
  end
end
