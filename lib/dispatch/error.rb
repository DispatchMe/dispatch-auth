module Dispatch
  module Error
    class AuthorizationHeaderMissing < StandardError
      def message
        'Authorization header required.'
      end
    end

    class NotAuthenticated < StandardError
      def message
        'You are not authorized to access this page.'
      end
    end
  end
end
