require_relative 'auth/errors'

module Dispatch
  module Auth
    def self.authenticate_request!(env)
      connection = Faraday.new(ENV['AUTH_ENDPOINT_URL'], ssl: { verify: true })

      request_env = Rack::Request.new(env)
      auth_header = request_env.env['HTTP_AUTHORIZATION']

      unless auth_header
        token = (request_env.params['access_token'] || request_env.params['bearer_token'])
        auth_header = "Bearer #{token}" if token
      end

      unless auth_header
        raise Dispatch::Auth::TokenMissingError
      end

      connection.headers['Authorization'] = auth_header
      response = connection.get

      case response.status
        when 401
          raise Dispatch::Auth::NotAuthenticatedError
        when 403
          raise Dispatch::Auth::NotAuthorizedError
      end
    end
  end
end
