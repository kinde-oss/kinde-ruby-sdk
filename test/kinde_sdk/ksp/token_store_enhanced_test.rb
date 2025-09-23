require "test_helper"

class KindeSdk::TokenStoreEnhancedTest < ActiveSupport::TestCase
  setup do
    KindeSdk::KSP.disable
    KindeSdk::KSP.enable
    
    @sample_tokens = {
      access_token: 'sample_access_token_123',
      refresh_token: 'sample_refresh_token_456',
      expires_at: Time.now.to_i + 3600,
      id_token: 'sample_id_token_789'
    }
  end

  teardown do
    KindeSdk::KSP.disable
  end

  test "initializes without tokens" do
    token_store = KindeSdk::TokenStoreEnhanced.new
    assert_nil token_store.tokens
    assert_nil token_store.bearer_token
    assert_nil token_store.expires_at
  end

  test "initializes with provided tokens" do
    token_store = KindeSdk::TokenStoreEnhanced.new(@sample_tokens)
    assert_equal 'sample_access_token_123', token_store.bearer_token
    assert_equal @sample_tokens[:expires_at], token_store.expires_at
    assert_equal 'sample_access_token_123', token_store.tokens[:access_token]
    assert_equal 'sample_refresh_token_456', token_store.tokens[:refresh_token]
  end

  test "handles string keys during initialization" do
    string_key_tokens = @sample_tokens.transform_keys(&:to_s)
    token_store = KindeSdk::TokenStoreEnhanced.new(string_key_tokens)
    assert_equal 'sample_access_token_123', token_store.bearer_token
  end

  test "sets tokens and updates internal state" do
    token_store = KindeSdk::TokenStoreEnhanced.new
    token_store.set_tokens(@sample_tokens)
    
    assert_equal 'sample_access_token_123', token_store.bearer_token
    assert_equal @sample_tokens[:expires_at], token_store.expires_at
    assert_equal 'sample_refresh_token_456', token_store.tokens[:refresh_token]
  end

  test "handles nil tokens in set_tokens" do
    token_store = KindeSdk::TokenStoreEnhanced.new
    token_store.set_tokens(nil)
    
    assert_equal({}, token_store.tokens)
    assert_nil token_store.bearer_token
    assert_nil token_store.expires_at
  end

  test "converts string keys to symbols" do
    token_store = KindeSdk::TokenStoreEnhanced.new
    string_key_tokens = @sample_tokens.transform_keys(&:to_s)
    token_store.set_tokens(string_key_tokens)
    
    assert token_store.tokens.keys.all? { |key| key.is_a?(Symbol) }
  end

  test "returns processed tokens from set_tokens" do
    token_store = KindeSdk::TokenStoreEnhanced.new
    result = token_store.set_tokens(@sample_tokens)
    assert_equal token_store.tokens, result
  end

  test "encrypts session data when KSP is enabled" do
    token_store = KindeSdk::TokenStoreEnhanced.new(@sample_tokens)
    session_data = token_store.to_session
    
    assert_not_equal 'sample_access_token_123', session_data[:access_token]
    assert_not_equal 'sample_refresh_token_456', session_data[:refresh_token]
    
    # Verify values can be decrypted
    decrypted_access = KindeSdk::KSP.decrypt(session_data[:access_token])
    decrypted_refresh = KindeSdk::KSP.decrypt(session_data[:refresh_token])
    decrypted_expires = KindeSdk::KSP.decrypt(session_data[:expires_at])
    
    assert_equal 'sample_access_token_123', decrypted_access
    assert_equal 'sample_refresh_token_456', decrypted_refresh
    assert_equal @sample_tokens[:expires_at], decrypted_expires.to_i
  end

  test "skips nil values in to_session" do
    tokens_with_nils = {
      access_token: 'access_token_123',
      refresh_token: nil,
      expires_at: Time.now.to_i + 3600
    }
    
    token_store = KindeSdk::TokenStoreEnhanced.new(tokens_with_nils)
    session_data = token_store.to_session
    
    assert session_data.key?(:access_token)
    assert_not session_data.key?(:refresh_token)
    assert session_data.key?(:expires_at)
  end

  test "handles empty token store in to_session" do
    empty_store = KindeSdk::TokenStoreEnhanced.new
    session_data = empty_store.to_session
    
    assert_kind_of Hash, session_data
    # Should not contain encrypted nil values
    session_data.values.each do |value|
      assert_not_nil value, "Session data should not contain nil values"
    end
  end

  test "returns unencrypted session data when KSP is disabled" do
    KindeSdk::KSP.disable
    token_store = KindeSdk::TokenStoreEnhanced.new(@sample_tokens)
    session_data = token_store.to_session
    
    assert_equal 'sample_access_token_123', session_data[:access_token]
    assert_equal 'sample_refresh_token_456', session_data[:refresh_token]
    assert_equal @sample_tokens[:expires_at], session_data[:expires_at]
  end

  test "creates TokenStore from encrypted session data" do
    # Create encrypted session data
    original_store = KindeSdk::TokenStoreEnhanced.new(@sample_tokens)
    encrypted_session = original_store.to_session
    
    # Recreate from session
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(encrypted_session)
    
    assert_kind_of KindeSdk::TokenStoreEnhanced, restored_store
    assert_equal 'sample_access_token_123', restored_store.bearer_token
    assert_equal 'sample_refresh_token_456', restored_store.tokens[:refresh_token]
    assert_equal @sample_tokens[:expires_at], restored_store.expires_at
  end

  test "handles partially encrypted session data" do
    encrypted_session = {
      access_token: KindeSdk::KSP.encrypt('access_token_123'),
      refresh_token: nil,  # Nil value
      expires_at: KindeSdk::KSP.encrypt((Time.now.to_i + 3600).to_s)
    }
    
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(encrypted_session)
    
    assert_equal 'access_token_123', restored_store.bearer_token
    assert_nil restored_store.tokens[:refresh_token]
  end

  test "handles corrupted encrypted data gracefully" do
    corrupted_session = {
      access_token: 'corrupted_data_not_encrypted',
      refresh_token: KindeSdk::KSP.encrypt('valid_refresh_token'),
      expires_at: 'invalid_timestamp'
    }
    
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(corrupted_session)
    
    # Should handle gracefully
    assert_kind_of KindeSdk::TokenStoreEnhanced, restored_store
  end

  test "creates TokenStore from unencrypted session data when KSP disabled" do
    KindeSdk::KSP.disable
    
    unencrypted_session = {
      access_token: 'sample_access_token_123',
      refresh_token: 'sample_refresh_token_456',
      expires_at: @sample_tokens[:expires_at]
    }
    
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(unencrypted_session)
    
    assert_equal 'sample_access_token_123', restored_store.bearer_token
    assert_equal 'sample_refresh_token_456', restored_store.tokens[:refresh_token]
    assert_equal @sample_tokens[:expires_at], restored_store.expires_at
  end

  test "returns nil for nil session data" do
    result = KindeSdk::TokenStoreEnhanced.from_session(nil)
    assert_nil result
  end

  test "creates TokenStore for empty hash" do
    result = KindeSdk::TokenStoreEnhanced.from_session({})
    assert_kind_of KindeSdk::TokenStoreEnhanced, result
    assert_nil result.bearer_token
  end

  test "maintains data integrity through multiple round-trips" do
    # Create original token store
    original_store = KindeSdk::TokenStoreEnhanced.new(@sample_tokens)
    
    # Convert to encrypted session and back multiple times
    5.times do
      encrypted_session = original_store.to_session
      restored_store = KindeSdk::TokenStoreEnhanced.from_session(encrypted_session)
      
      assert_equal original_store.bearer_token, restored_store.bearer_token
      assert_equal original_store.tokens[:refresh_token], restored_store.tokens[:refresh_token]
      assert_equal original_store.expires_at, restored_store.expires_at
      
      original_store = restored_store
    end
  end

  test "handles complex token data structures" do
    complex_tokens = {
      access_token: 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...',
      refresh_token: 'rt_refresh_token_with_special_chars_@#$%^&*()',
      expires_at: Time.now.to_i + 7200,
      id_token: '{"sub":"user123","exp":1234567890,"aud":["app1","app2"]}',
      scope: 'openid profile email offline_access',
      token_type: 'Bearer'
    }
    
    original_store = KindeSdk::TokenStoreEnhanced.new(complex_tokens)
    encrypted_session = original_store.to_session
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(encrypted_session)
    
    assert_equal complex_tokens[:access_token], restored_store.bearer_token
    assert_equal complex_tokens[:id_token], restored_store.tokens[:id_token]
    assert_equal complex_tokens[:scope], restored_store.tokens[:scope]
  end

  test "integrates with Rails-like session storage" do
    mock_rails_session = {}
    
    # Store tokens in Rails session
    token_store = KindeSdk::TokenStoreEnhanced.new(@sample_tokens)
    mock_rails_session[:kinde_tokens] = token_store.to_session
    
    # Verify session contains encrypted data
    assert_not_equal 'sample_access_token_123', mock_rails_session[:kinde_tokens][:access_token]
    
    # Restore from Rails session
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(mock_rails_session[:kinde_tokens])
    
    assert_equal 'sample_access_token_123', restored_store.bearer_token
    assert_equal 'sample_refresh_token_456', restored_store.tokens[:refresh_token]
  end

  test "handles tokens with special characters" do
    special_tokens = {
      access_token: 'token.with-special_chars@domain:8080/path?query=value&other=123',
      refresh_token: 'refresh+token/with=unsafe&chars<>"\';--',
      expires_at: Time.now.to_i + 3600
    }
    
    token_store = KindeSdk::TokenStoreEnhanced.new(special_tokens)
    encrypted_session = token_store.to_session
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(encrypted_session)
    
    assert_equal special_tokens[:access_token], restored_store.bearer_token
    assert_equal special_tokens[:refresh_token], restored_store.tokens[:refresh_token]
  end

  test "handles binary data in tokens" do
    binary_token = (0..255).map(&:chr).join.force_encoding('ASCII-8BIT')
    binary_tokens = {
      access_token: binary_token,
      refresh_token: 'normal_refresh_token',
      expires_at: Time.now.to_i + 3600
    }
    
    token_store = KindeSdk::TokenStoreEnhanced.new(binary_tokens)
    encrypted_session = token_store.to_session
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(encrypted_session)
    
    assert_equal binary_token.bytes, restored_store.bearer_token.bytes
    assert_equal 'ASCII-8BIT', restored_store.bearer_token.encoding.name
  end

  test "encrypts each session conversion with different ciphertext" do
    token_store = KindeSdk::TokenStoreEnhanced.new(@sample_tokens)
    
    session1 = token_store.to_session
    session2 = token_store.to_session
    
    # Same plaintext should produce different ciphertext due to random IVs
    assert_not_equal session1[:access_token], session2[:access_token]
    assert_not_equal session1[:refresh_token], session2[:refresh_token]
    
    # But both should decrypt to same values
    restored1 = KindeSdk::TokenStoreEnhanced.from_session(session1)
    restored2 = KindeSdk::TokenStoreEnhanced.from_session(session2)
    
    assert_equal restored1.bearer_token, restored2.bearer_token
    assert_equal restored1.tokens[:refresh_token], restored2.tokens[:refresh_token]
  end

  test "handles large token sets efficiently" do
    large_tokens = {}
    50.times do |i|  # Reduced for faster test execution
      large_tokens["token_#{i}".to_sym] = "token_value_#{i}" * 10
    end
    large_tokens[:access_token] = 'main_access_token'
    
    start_time = Time.now
    token_store = KindeSdk::TokenStoreEnhanced.new(large_tokens)
    encrypted_session = token_store.to_session
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(encrypted_session)
    end_time = Time.now
    
    # Should complete within reasonable time
    assert (end_time - start_time) < 2.0, "Operation took too long: #{end_time - start_time} seconds"
    assert_equal 'main_access_token', restored_store.bearer_token
  end

  test "handles extremely long tokens" do
    long_token = 'x' * 10000  # 10KB token
    long_tokens = {
      access_token: long_token,
      refresh_token: 'normal_refresh_token',
      expires_at: Time.now.to_i + 3600
    }
    
    token_store = KindeSdk::TokenStoreEnhanced.new(long_tokens)
    encrypted_session = token_store.to_session
    restored_store = KindeSdk::TokenStoreEnhanced.from_session(encrypted_session)
    
    assert_equal long_token, restored_store.bearer_token
    assert_equal 10000, restored_store.bearer_token.length
  end
end
