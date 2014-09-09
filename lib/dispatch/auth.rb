module Dispatch
  module Auth
    def self.authenticate_write_request!(env)
      return true if %w[GET OPTIONS].include?(env['REQUEST_METHOD'])

      auth_header = Rack::Request.new(env).env['HTTP_AUTHORIZATION']

      unless auth_header
        raise Dispatch::Error::AuthorizationHeaderMissing
      end

      connection = Faraday.new(ENV['AUTH_ENDPOINT_URL'], ssl: { verify: false })
      connection.headers['Authorization'] = auth_header
      response = connection.get

      unless response.status == 200
        raise Dispatch::Error::NotAuthenticated
      end
    end
  end
end
