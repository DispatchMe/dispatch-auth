require 'httparty'
require_relative 'auth/errors'

module Dispatch
  module Auth
    include HTTParty

    class << self
      def authenticate_request!(env)
        prepare_headers(env)
        resolve_errors get(ENV['AUTH_ENDPOINT_URL'])
      end

      def get_me(env)
        prepare_headers(env)
        resolve_errors get(ENV['AUTH_ENDPOINT_URL'])
      end

    private
      def get_auth_header(env)
        r = Rack::Request.new(env)
        header = r.env['HTTP_AUTHORIZATION']
        token = r.params['access_token'] || r.params['bearer_token']
        header ||= "Bearer #{token}" if token
        raise(Dispatch::Auth::TokenMissingError) unless header
        header
      end

      def prepare_headers(env)
        headers.merge!('Content-Type' => 'application/json')
        headers.merge!('Authorization' => get_auth_header(env)) || raise(Dispatch::Auth::TokenMissingError)
      end

      def resolve_errors(response)
        case response.code
        when 401
          raise Dispatch::Auth::NotAuthenticatedError
        when 403
          raise Dispatch::Auth::NotAuthorizedError
        end
        response
      end
    end
  end
end
