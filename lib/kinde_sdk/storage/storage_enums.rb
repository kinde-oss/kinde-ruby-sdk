module KindeSdk
  module Storage
    # Storage key constants - matches PHP SDK StorageEnums
    class StorageEnums
      TOKEN = 'token'.freeze
      STATE = 'state'.freeze
      CODE_VERIFIER = 'code_verifier'.freeze
      AUTH_STATUS = 'auth_status'.freeze
      USER_PROFILE = 'user_profile'.freeze
      JWKS_CACHE = 'jwks_cache'.freeze
    end
  end
end
