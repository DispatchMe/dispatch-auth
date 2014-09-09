module Dispatch
  module Auth
    class TokenMissingError < StandardError
      def message
        'Authorization header required.'
      end
    end

    class NotAuthenticatedError < StandardError
      def message
        'Request is not authenticated.'
      end
    end

    class NotAuthorizedError < StandardError
      def message
        'You are not authorized to access this page.'
      end
    end
  end
end
