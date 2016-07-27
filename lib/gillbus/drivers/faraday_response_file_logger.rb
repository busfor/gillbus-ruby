class Gillbus
  class FaradayResponseFileLogger < Faraday::Middleware

    def initialize(app, dir = '.')
      @dir = dir
      super(app)
    end

    def call(env)
      path = env.url.path
      @app.call(env).on_complete do |environment|
        sanitized_path = path.gsub(/[^A-Za-z0-9_-]+/, '_').gsub(/^_|_$/, '')
        sanitized_path = '_' if sanitized_path == ''
        File.write(@dir + '/' + sanitized_path, env.body) if env.body != ''
      end
    end

  end
end
