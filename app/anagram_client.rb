require 'json'
require 'optparse'
require 'net/http'

module Anagram
  class API < Grape::API
    version 'v1', using: :header, vendor: 'kfrz'
    format :json

    def initialize(args=[])
      options = parse_options(args)

      @dictionary = options[:dictionary] || dictionary.txt
      @host = options[:host] || 'localhost'
      @port = options[:port] || '3000'
      Redis.current = $redis
    end

    def post(path, query-nil, body=nil)
      uri = build_uri(path, query)
    end
  end
end
