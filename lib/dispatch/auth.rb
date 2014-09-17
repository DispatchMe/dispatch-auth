require 'httparty'
require_relative 'auth/errors'

module Dispatch
  module Auth
    include HTTParty

    class << self
      def authenticate_request!(env)
        headers.merge!('Content-Type' => 'application/json')
        headers.merge!('Authorization' => get_auth_header(env)) || raise(Dispatch::Auth::TokenMissingError)

        response = get(ENV['AUTH_ENDPOINT_URL'])

        case response.code
          when 401
            raise Dispatch::Auth::NotAuthenticatedError
          when 403
            raise Dispatch::Auth::NotAuthorizedError
        end
      end

      def get_auth_header(env)
        r = Rack::Request.new(env)
        header = r.env['HTTP_AUTHORIZATION']
        token = r.params['access_token'] || r.params['bearer_token']
        header ||= "Bearer #{token}" if token
        raise(Dispatch::Auth::TokenMissingError) unless header
        header
      end
      private :get_auth_header
    end
  end
end
