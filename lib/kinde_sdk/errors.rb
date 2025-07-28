module KindeSdk
    class Error < StandardError; end
    class APIError < Error; end
    class AuthenticationError < APIError; end
    class AuthorizationError < APIError; end
    class RateLimitError < APIError; end
  end