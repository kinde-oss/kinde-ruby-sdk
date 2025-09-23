require "test_helper"

class KindeSdk::KSPTest < ActiveSupport::TestCase
  setup do
    KindeSdk::KSP.disable
    ENV.delete('KINDE_KSP_KEY')
  end

  teardown do
    KindeSdk::KSP.disable
    ENV.delete('KINDE_KSP_KEY')
  end

  test "enables KSP with auto-generated key" do
    assert KindeSdk::KSP.enable
    assert KindeSdk::KSP.enabled?
    assert KindeSdk::KSP.status[:enabled]
    assert KindeSdk::KSP.status[:key_available]
  end

  test "generates valid encryption key" do
    key = KindeSdk::KSP.generate_key
    assert_kind_of String, key
    assert key.length > 40
    
    decoded = Base64.strict_decode64(key)
    assert_equal 32, decoded.bytesize
  end

  test "encrypts and decrypts data successfully" do
    KindeSdk::KSP.enable
    test_data = 'sensitive user token data'
    
    encrypted = KindeSdk::KSP.encrypt(test_data)
    assert_not_equal test_data, encrypted
    assert_kind_of String, encrypted
    
    decrypted = KindeSdk::KSP.decrypt(encrypted)
    assert_equal test_data, decrypted
  end

  test "handles empty string data" do
    KindeSdk::KSP.enable
    encrypted = KindeSdk::KSP.encrypt('')
    decrypted = KindeSdk::KSP.decrypt(encrypted)
    assert_equal '', decrypted
  end

  test "handles nil data in non-strict mode" do
    KindeSdk::KSP.enable(strict: false)
    encrypted = KindeSdk::KSP.encrypt(nil)
    decrypted = KindeSdk::KSP.decrypt(encrypted)
    assert_equal '', decrypted
  end

  test "rejects nil data in strict mode" do
    KindeSdk::KSP.enable(strict: true)
    assert_raises ArgumentError do
      KindeSdk::KSP.encrypt(nil)
    end
  end

  test "handles large data" do
    KindeSdk::KSP.enable
    large_data = 'x' * 10000
    encrypted = KindeSdk::KSP.encrypt(large_data)
    decrypted = KindeSdk::KSP.decrypt(large_data)
    assert_equal large_data, decrypted
  end

  test "handles unicode data" do
    KindeSdk::KSP.enable
    unicode_data = 'Hello 世界 🌍 مرحبا العالم'
    encrypted = KindeSdk::KSP.encrypt(unicode_data)
    decrypted = KindeSdk::KSP.decrypt(encrypted)
    assert_equal unicode_data, decrypted
    assert_equal unicode_data.encoding, decrypted.encoding
  end

  test "handles binary data" do
    KindeSdk::KSP.enable
    binary_data = (0..255).map(&:chr).join.force_encoding('ASCII-8BIT')
    encrypted = KindeSdk::KSP.encrypt(binary_data)
    decrypted = KindeSdk::KSP.decrypt(encrypted)
    
    assert_equal binary_data.bytes, decrypted.bytes
    assert_equal 'ASCII-8BIT', decrypted.encoding.name
  end

  test "disables KSP successfully" do
    KindeSdk::KSP.enable
    assert KindeSdk::KSP.enabled?
    
    KindeSdk::KSP.disable
    assert_not KindeSdk::KSP.enabled?
    assert_not KindeSdk::KSP.status[:enabled]
    assert_not KindeSdk::KSP.status[:key_available]
    assert_not KindeSdk::KSP.strict
    assert_equal 'default', KindeSdk::KSP.key_id
  end

  test "fails gracefully when disabled in non-strict mode" do
    KindeSdk::KSP.disable
    test_data = 'test data'
    
    encrypted = KindeSdk::KSP.encrypt(test_data)
    assert_equal test_data, encrypted
    
    decrypted = KindeSdk::KSP.decrypt(test_data)
    assert_equal test_data, decrypted
  end

  test "fails hard when disabled in strict mode" do
    KindeSdk::KSP.disable
    KindeSdk::KSP.instance_variable_set(:@strict, true)
    
    assert_raises RuntimeError do
      KindeSdk::KSP.encrypt('test data')
    end
    
    assert_raises RuntimeError do
      KindeSdk::KSP.decrypt('test data')
    end
  ensure
    KindeSdk::KSP.instance_variable_set(:@strict, false)
  end

  test "uses environment variable key" do
    test_key = KindeSdk::KSP.generate_key
    ENV['KINDE_KSP_KEY'] = test_key
    
    assert KindeSdk::KSP.enable
    assert KindeSdk::KSP.enabled?
  end

  test "uses custom environment variable" do
    test_key = KindeSdk::KSP.generate_key
    ENV['CUSTOM_KSP_KEY'] = test_key
    
    assert KindeSdk::KSP.enable(env_var: 'CUSTOM_KSP_KEY')
    assert KindeSdk::KSP.enabled?
  end

  test "uses provided custom key" do
    test_key = KindeSdk::KSP.generate_key
    assert KindeSdk::KSP.enable(key: test_key)
    assert KindeSdk::KSP.enabled?
  end

  test "validates key format" do
    assert_raises ArgumentError do
      KindeSdk::KSP.enable(key: 'invalid_key')
    end
  end

  test "validates key length" do
    short_key = Base64.strict_encode64('short_key')
    assert_raises ArgumentError do
      KindeSdk::KSP.enable(key: short_key)
    end
  end

  test "returns status information" do
    status = KindeSdk::KSP.status
    assert_kind_of Hash, status
    assert status.key?(:enabled)
    assert status.key?(:key_available)
    assert status.key?(:key_id)
    assert status.key?(:cipher_method)
    assert status.key?(:strict_mode)
    assert status.key?(:requirements_met)
  end

  test "performs quick setup" do
    result = KindeSdk::KSP.quick_setup
    assert_kind_of Hash, result
    assert result[:enabled]
    assert result[:key_generated]
    assert_not result[:key_existed]
    assert_kind_of String, result[:key_fingerprint]
    assert_kind_of Hash, result[:status]
  end

  test "storage hook encrypts for store operation" do
    KindeSdk::KSP.enable
    test_data = 'sensitive data'
    result = KindeSdk::KSP.storage_hook('store', test_data)
    
    assert_not_equal test_data, result
    assert_equal test_data, KindeSdk::KSP.decrypt(result)
  end

  test "storage hook decrypts for retrieve operation" do
    KindeSdk::KSP.enable
    test_data = 'sensitive data'
    encrypted = KindeSdk::KSP.encrypt(test_data)
    result = KindeSdk::KSP.storage_hook('retrieve', encrypted)
    
    assert_equal test_data, result
  end

  test "storage hook passes through unknown operations" do
    KindeSdk::KSP.enable
    test_data = 'test data'
    result = KindeSdk::KSP.storage_hook('unknown', test_data)
    assert_equal test_data, result
  end

  test "wraps storage object" do
    mock_storage = Object.new
    wrapper = KindeSdk::KSP.wrap_storage(mock_storage)
    assert_kind_of KindeSdk::KSP::StorageWrapper, wrapper
  end

  test "produces different encrypted output for same input" do
    KindeSdk::KSP.enable
    test_data = 'same input data'
    
    encrypted1 = KindeSdk::KSP.encrypt(test_data)
    encrypted2 = KindeSdk::KSP.encrypt(test_data)
    
    assert_not_equal encrypted1, encrypted2
    
    decrypted1 = KindeSdk::KSP.decrypt(encrypted1)
    decrypted2 = KindeSdk::KSP.decrypt(encrypted2)
    
    assert_equal test_data, decrypted1
    assert_equal test_data, decrypted2
  end

  test "generates consistent key fingerprint for same key" do
    test_key = KindeSdk::KSP.generate_key
    
    KindeSdk::KSP.enable(key: test_key)
    key_id1 = KindeSdk::KSP.key_id
    
    KindeSdk::KSP.disable
    KindeSdk::KSP.enable(key: test_key)
    key_id2 = KindeSdk::KSP.key_id
    
    assert_equal key_id1, key_id2
  end

  test "generates different key fingerprints for different keys" do
    key1 = KindeSdk::KSP.generate_key
    key2 = KindeSdk::KSP.generate_key
    
    KindeSdk::KSP.enable(key: key1)
    key_id1 = KindeSdk::KSP.key_id
    
    KindeSdk::KSP.disable
    KindeSdk::KSP.enable(key: key2)
    key_id2 = KindeSdk::KSP.key_id
    
    assert_not_equal key_id1, key_id2
  end

  test "handles corrupted encrypted data gracefully" do
    KindeSdk::KSP.enable
    corrupted_data = 'invalid_base64_data'
    
    result = KindeSdk::KSP.decrypt(corrupted_data)
    assert_equal corrupted_data, result
  end

  test "validates system requirements" do
    requirements = KindeSdk::KSP.send(:check_requirements)
    
    assert requirements[:openssl]
    assert requirements[:json]
    assert requirements[:securerandom]
    assert requirements[:base64]
    assert requirements[:digest]
    assert requirements[:aes_256_gcm]
    assert requirements[:all_passed]
  end

  test "creates properly structured encrypted payload" do
    KindeSdk::KSP.enable
    test_data = 'test data'
    encrypted = KindeSdk::KSP.encrypt(test_data)
    
    decoded = Base64.strict_decode64(encrypted)
    payload = JSON.parse(decoded, symbolize_names: true)
    
    assert payload.key?(:v)
    assert payload.key?(:k)
    assert payload.key?(:iv)
    assert payload.key?(:tag)
    assert payload.key?(:data)
    
    assert_equal 1, payload[:v]
    assert_kind_of String, payload[:k]
    assert_kind_of String, payload[:iv]
    assert_kind_of String, payload[:tag]
    assert_kind_of String, payload[:data]
  end

  test "enables only once when called multiple times" do
    assert KindeSdk::KSP.enable
    assert KindeSdk::KSP.enable  # Should return true without re-initializing
    assert KindeSdk::KSP.enabled?
  end

  test "fails when no key available in strict mode" do
    result = KindeSdk::KSP.enable(auto_generate: false, strict: true)
    assert_not result
    assert_not KindeSdk::KSP.enabled?
  end

  test "handles JSON data correctly" do
    KindeSdk::KSP.enable
    json_data = { user_id: 123, roles: ['admin', 'user'], metadata: { active: true } }.to_json
    
    encrypted = KindeSdk::KSP.encrypt(json_data)
    decrypted = KindeSdk::KSP.decrypt(encrypted)
    
    assert_equal json_data, decrypted
    
    parsed = JSON.parse(decrypted, symbolize_names: true)
    assert_equal 123, parsed[:user_id]
    assert_equal ['admin', 'user'], parsed[:roles]
    assert parsed[:metadata][:active]
  end
end
