require 'faraday'
require_relative 'auth/errors'

module Dispatch
  module Auth
    def self.authenticate_request!(env)
      connection = Faraday.new(ENV['AUTH_ENDPOINT_URL'], ssl: { verify: true })
      connection.headers['Authorization'] = get_auth_header(env) ||
        raise(Dispatch::Auth::TokenMissingError)
      response = connection.get

      case response.status
        when 401
          raise Dispatch::Auth::NotAuthenticatedError
        when 403
          raise Dispatch::Auth::NotAuthorizedError
      end
    end

  private

    def self.get_auth_header(env)
      r = Rack::Request.new(env)
      header = r.env['HTTP_AUTHORIZATION']
      token = r.params['access_token'] || r.params['bearer_token']
      header ||= "Bearer #{token}" if token
      raise(Dispatch::Auth::TokenMissingError) unless header
      header
    end
  end
end
