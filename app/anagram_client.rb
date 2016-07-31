require 'json'
require 'optparse'
require 'net/http'

module Anagram
  class API < Grape::API
    version 'v1', using: :header, vendor: 'kfrz'
    format :json
    prefix :api

    def initialize
      @word = ""
      Redis.current = $redis
    end

    def self.word
      Redis.current.set('word','mapped')
      Redis.current.get('word')
    end
  end
end
