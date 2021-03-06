module Anagram
  class App
    def initialize
      @rack_static = ::Rack::Static.new(
        lambda { [404, {}, []] },
        root: File.expand_path('../../public', __FILE__),
        urls: ['/']
      )
    end

    def self.instance
      @instance ||= build_instance
      run Anagram::App.new
    end

    def call(env)
      response = Anagram::API.call(env)

      # Check if the App wants us to pass the response along to others
      if response[1]['X-Cascade'] == 'pass'
        # static files
        request_path = env['PATH_INFO']
        @filenames.each do |path|
          response = @rack_static.call(env.merge('PATH_INFO' => request_path + path))
          return response if response[0] != 404
        end
      end

      # Serve error pages or respond with API response
      case response[0]
      when 404, 500
        content = @rack_static.call(env.merge('PATH_INFO' => "/errors/#{response[0]}.html"))
        [response[0], content[1], content[2]]
      else
        response
      end
    end

    private

    def build_instance
      Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource ':anagrams/*', headers: :any, methods: [:get, :delete]
            resource ':words/*', headers: :any, methods: :any
          end
        end
      end
    end
  end
end
