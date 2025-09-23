require "test_helper"

class KindeSdk::KSP::StorageWrapperTest < ActiveSupport::TestCase
  setup do
    KindeSdk::KSP.disable
    KindeSdk::KSP.enable
    @mock_storage = MockStorage.new
    @wrapper = KindeSdk::KSP::StorageWrapper.new(@mock_storage)
  end

  teardown do
    KindeSdk::KSP.disable
  end

  test "initializes with storage reference" do
    wrapper = KindeSdk::KSP::StorageWrapper.new(@mock_storage)
    assert_equal @mock_storage, wrapper.instance_variable_get(:@storage)
  end

  test "encrypts string values on set_item" do
    test_value = 'sensitive_token_data'
    @wrapper.set_item('test_key', test_value)
    
    stored_value = @mock_storage.data['test_key']
    assert_not_equal test_value, stored_value
    assert_equal test_value, KindeSdk::KSP.decrypt(stored_value)
  end

  test "handles empty string values" do
    @wrapper.set_item('empty_key', '')
    
    stored_value = @mock_storage.data['empty_key']
    assert_equal '', KindeSdk::KSP.decrypt(stored_value)
  end

  test "passes through non-string values unchanged" do
    hash_value = { user_id: 123, active: true }
    @wrapper.set_item('hash_key', hash_value)
    
    stored_value = @mock_storage.data['hash_key']
    assert_equal hash_value, stored_value
  end

  test "passes through nil values unchanged" do
    @wrapper.set_item('nil_key', nil)
    
    stored_value = @mock_storage.data['nil_key']
    assert_nil stored_value
  end

  test "passes through numeric values unchanged" do
    @wrapper.set_item('num_key', 12345)
    
    stored_value = @mock_storage.data['num_key']
    assert_equal 12345, stored_value
  end

  test "decrypts retrieved string values" do
    test_value = 'sensitive_token_data'
    encrypted_value = KindeSdk::KSP.encrypt(test_value)
    @mock_storage.data['test_key'] = encrypted_value
    
    result = @wrapper.get_item('test_key')
    assert_equal test_value, result
  end

  test "handles empty encrypted values" do
    encrypted_empty = KindeSdk::KSP.encrypt('')
    @mock_storage.data['empty_key'] = encrypted_empty
    
    result = @wrapper.get_item('empty_key')
    assert_equal '', result
  end

  test "uses default value when key not found" do
    default_value = 'default_token'
    
    result = @wrapper.get_item('missing_key', default_value)
    assert_equal default_value, result
  end

  test "passes through non-string values on get_item" do
    hash_value = { user_id: 123, active: true }
    @mock_storage.data['hash_key'] = hash_value
    
    result = @wrapper.get_item('hash_key')
    assert_equal hash_value, result
  end

  test "handles nil values on get_item" do
    @mock_storage.data['nil_key'] = nil
    
    result = @wrapper.get_item('nil_key')
    assert_nil result
  end

  test "does not attempt decryption when value equals default" do
    default_value = 'default_value'
    @mock_storage.data['key'] = default_value
    
    # Mock KSP.decrypt to track calls
    decrypt_called = false
    original_decrypt = KindeSdk::KSP.method(:decrypt)
    KindeSdk::KSP.define_singleton_method(:decrypt) do |value|
      decrypt_called = true
      original_decrypt.call(value)
    end
    
    result = @wrapper.get_item('key', default_value)
    
    # Restore original method
    KindeSdk::KSP.define_singleton_method(:decrypt, original_decrypt)
    
    assert_equal default_value, result
    assert_not decrypt_called, "decrypt should not be called when value equals default"
  end

  test "forwards remove_item to wrapped storage" do
    @mock_storage.data['test_key'] = 'value'
    @wrapper.remove_item('test_key')
    
    assert_not @mock_storage.data.key?('test_key')
  end

  test "forwards clear to wrapped storage" do
    @mock_storage.data['key1'] = 'value1'
    @mock_storage.data['key2'] = 'value2'
    @wrapper.clear
    
    assert_empty @mock_storage.data
  end

  test "handles missing clear method gracefully" do
    limited_storage = MockLimitedStorage.new
    limited_wrapper = KindeSdk::KSP::StorageWrapper.new(limited_storage)
    
    assert_nothing_raised do
      limited_wrapper.clear
    end
  end

  test "forwards unknown methods to wrapped storage" do
    result = @wrapper.custom_method('arg1', 'arg2')
    assert_equal 'custom_method called with arg1, arg2', result
  end

  test "forwards methods with blocks" do
    block_result = nil
    @wrapper.method_with_block { |value| block_result = value }
    
    assert_equal 'block called', block_result
  end

  test "raises NoMethodError for unsupported methods" do
    limited_storage = MockLimitedStorage.new
    limited_wrapper = KindeSdk::KSP::StorageWrapper.new(limited_storage)
    
    assert_raises NoMethodError do
      limited_wrapper.nonexistent_method
    end
  end

  test "responds to methods supported by wrapped storage" do
    assert @wrapper.respond_to?(:custom_method)
    assert @wrapper.respond_to?(:method_with_block)
    assert_not @wrapper.respond_to?(:nonexistent_method)
  end

  test "provides transparent encryption for session-like storage" do
    # Store multiple values
    @wrapper.set_item('access_token', 'secret_access_token_123')
    @wrapper.set_item('refresh_token', 'secret_refresh_token_456')
    @wrapper.set_item('user_id', 'user_789')
    
    # Verify values are encrypted in storage
    assert_not_equal 'secret_access_token_123', @mock_storage.data['access_token']
    assert_not_equal 'secret_refresh_token_456', @mock_storage.data['refresh_token']
    assert_not_equal 'user_789', @mock_storage.data['user_id']
    
    # Verify values are decrypted when retrieved
    assert_equal 'secret_access_token_123', @wrapper.get_item('access_token')
    assert_equal 'secret_refresh_token_456', @wrapper.get_item('refresh_token')
    assert_equal 'user_789', @wrapper.get_item('user_id')
    
    # Test removal
    @wrapper.remove_item('refresh_token')
    assert_nil @wrapper.get_item('refresh_token')
    
    # Test clear
    @wrapper.clear
    assert_nil @wrapper.get_item('access_token')
    assert_nil @wrapper.get_item('user_id')
  end

  test "passes through values without encryption when KSP disabled" do
    KindeSdk::KSP.disable
    wrapper = KindeSdk::KSP::StorageWrapper.new(@mock_storage)
    
    test_value = 'unencrypted_value'
    wrapper.set_item('key', test_value)
    
    assert_equal test_value, @mock_storage.data['key']
    
    result = wrapper.get_item('key')
    assert_equal test_value, result
  end

  test "handles binary data correctly" do
    binary_data = (0..255).map(&:chr).join.force_encoding('ASCII-8BIT')
    @wrapper.set_item('binary_key', binary_data)
    
    stored_value = @mock_storage.data['binary_key']
    assert_not_equal binary_data, stored_value
    
    decrypted = KindeSdk::KSP.decrypt(stored_value)
    assert_equal binary_data.bytes, decrypted.bytes
    assert_equal 'ASCII-8BIT', decrypted.encoding.name
    
    result = @wrapper.get_item('binary_key')
    assert_equal binary_data.bytes, result.bytes
    assert_equal 'ASCII-8BIT', result.encoding.name
  end

  test "preserves unicode data correctly" do
    unicode_data = 'Hello 世界 🌍 مرحبا'
    @wrapper.set_item('unicode_key', unicode_data)
    
    stored_value = @mock_storage.data['unicode_key']
    decrypted = KindeSdk::KSP.decrypt(stored_value)
    assert_equal unicode_data, decrypted
    assert_equal unicode_data.encoding, decrypted.encoding
    
    result = @wrapper.get_item('unicode_key')
    assert_equal unicode_data, result
    assert_equal unicode_data.encoding, result.encoding
  end

  private

  class MockStorage
    attr_reader :data
    
    def initialize
      @data = {}
    end
    
    def set_item(key, value)
      @data[key] = value
    end
    
    def get_item(key, default = nil)
      @data[key] || default
    end
    
    def remove_item(key)
      @data.delete(key)
    end
    
    def clear
      @data.clear
    end
    
    def custom_method(arg1, arg2)
      "custom_method called with #{arg1}, #{arg2}"
    end
    
    def method_with_block(&block)
      block.call('block called')
    end
    
    def respond_to?(method_name, include_private = false)
      [:set_item, :get_item, :remove_item, :clear, :custom_method, :method_with_block].include?(method_name.to_sym) || super
    end
  end

  class MockLimitedStorage
    def initialize
      @data = {}
    end
    
    def set_item(key, value)
      @data[key] = value
    end
    
    def get_item(key, default = nil)
      @data[key] || default
    end
  end
end
