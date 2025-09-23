require 'spec_helper'
require 'securerandom'
require 'base64'
require 'json'
require 'openssl'

RSpec.describe KindeSdk::KSP do
  before do
    # Disable KSP and reset state before each test
    described_class.disable
    ENV.delete('KINDE_KSP_KEY')
  end

  after do
    # Clean up after each test
    described_class.disable
    ENV.delete('KINDE_KSP_KEY')
  end

  describe '.enable' do
    context 'with auto-generated key' do
      it 'enables KSP successfully with default options' do
        result = described_class.enable
        expect(result).to be true
        expect(described_class.enabled?).to be true
        expect(described_class.status[:enabled]).to be true
        expect(described_class.status[:key_available]).to be true
      end

      it 'enables KSP with custom options' do
        result = described_class.enable(auto_generate: true, strict: false)
        expect(result).to be true
        expect(described_class.enabled?).to be true
        expect(described_class.strict).to be false
      end
    end

    context 'with environment variable key' do
      let(:test_key) { described_class.generate_key }

      before do
        ENV['KINDE_KSP_KEY'] = test_key
      end

      it 'enables KSP using environment variable' do
        result = described_class.enable
        expect(result).to be true
        expect(described_class.enabled?).to be true
      end

      it 'uses custom environment variable name' do
        ENV.delete('KINDE_KSP_KEY')
        ENV['CUSTOM_KSP_KEY'] = test_key

        result = described_class.enable(env_var: 'CUSTOM_KSP_KEY')
        expect(result).to be true
        expect(described_class.enabled?).to be true
      end
    end

    context 'with custom key' do
      let(:test_key) { described_class.generate_key }

      it 'enables KSP with provided key' do
        result = described_class.enable(key: test_key)
        expect(result).to be true
        expect(described_class.enabled?).to be true
      end
    end

    context 'in strict mode' do
      it 'enables in strict mode' do
        result = described_class.enable(strict: true)
        expect(result).to be true
        expect(described_class.strict).to be true
      end

      it 'fails when no key available in strict mode' do
        expect { described_class.enable(auto_generate: false, strict: true) }.to raise_error(RuntimeError)
        expect(described_class.enabled?).to be false
      end
    end

    context 'with invalid key' do
      it 'handles invalid base64 key' do
        expect { described_class.enable(key: 'invalid_key') }.to raise_error(ArgumentError)
      end

      it 'handles key with wrong length' do
        short_key = Base64.strict_encode64(SecureRandom.random_bytes(16))
        expect { described_class.enable(key: short_key) }.to raise_error(ArgumentError)
      end
    end

    it 'only enables once when called multiple times' do
      expect(described_class.enable).to be true
      expect(described_class.enable).to be true  # Should return true without re-initializing
    end
  end

  describe '.disable' do
    before do
      described_class.enable
    end

    it 'disables KSP successfully' do
      described_class.disable
      expect(described_class.enabled?).to be false
      expect(described_class.status[:enabled]).to be false
      expect(described_class.status[:key_available]).to be false
      expect(described_class.strict).to be false
      expect(described_class.key_id).to eq('default')
    end
  end

  describe '.encrypt and .decrypt' do
    before do
      described_class.enable
    end

    context 'with standard data' do
      let(:test_data) { 'sensitive user token data' }

      it 'encrypts and decrypts data successfully' do
        encrypted = described_class.encrypt(test_data)
        expect(encrypted).not_to eq(test_data)
        expect(encrypted).to be_a(String)

        decrypted = described_class.decrypt(encrypted)
        expect(decrypted).to eq(test_data)
      end

      it 'produces different encrypted output for same input' do
        encrypted1 = described_class.encrypt(test_data)
        encrypted2 = described_class.encrypt(test_data)
        expect(encrypted1).not_to eq(encrypted2)  # Different IVs
      end

      it 'decrypts to same result regardless of different encrypted versions' do
        encrypted1 = described_class.encrypt(test_data)
        encrypted2 = described_class.encrypt(test_data)

        decrypted1 = described_class.decrypt(encrypted1)
        decrypted2 = described_class.decrypt(encrypted2)

        expect(decrypted1).to eq(test_data)
        expect(decrypted2).to eq(test_data)
      end
    end

    context 'with edge case data' do
      it 'handles empty string' do
        encrypted = described_class.encrypt('')
        decrypted = described_class.decrypt(encrypted)
        expect(decrypted).to eq('')
      end

      it 'handles nil data in non-strict mode' do
        described_class.disable
        described_class.enable(strict: false)

        encrypted = described_class.encrypt(nil)
        decrypted = described_class.decrypt(encrypted)
        expect(decrypted).to eq('')
      end

      it 'rejects nil data in strict mode' do
        described_class.disable
        described_class.enable(strict: true)

        expect { described_class.encrypt(nil) }.to raise_error(ArgumentError, 'Cannot encrypt nil data in strict mode')
      end

      it 'handles large data' do
        large_data = 'x' * 10000
        encrypted = described_class.encrypt(large_data)
        decrypted = described_class.decrypt(encrypted)
        expect(decrypted).to eq(large_data)
      end

      it 'handles unicode data' do
        unicode_data = 'Hello 世界 🌍 مرحبا العالم'
        encrypted = described_class.encrypt(unicode_data)
        decrypted = described_class.decrypt(encrypted)
        expect(decrypted).to eq(unicode_data)
        expect(decrypted.encoding).to eq(unicode_data.encoding)
      end

      it 'handles binary data' do
        binary_data = (0..255).map(&:chr).join.force_encoding('ASCII-8BIT')
        encrypted = described_class.encrypt(binary_data)
        decrypted = described_class.decrypt(encrypted)
        
        expect(decrypted.bytes).to eq(binary_data.bytes)
        expect(decrypted.encoding.name).to eq('ASCII-8BIT')
      end
    end

    context 'with JSON data' do
      let(:json_data) { { user_id: 123, roles: ['admin', 'user'], metadata: { active: true } }.to_json }

      it 'handles JSON data' do
        encrypted = described_class.encrypt(json_data)
        decrypted = described_class.decrypt(encrypted)
        expect(decrypted).to eq(json_data)
        
        parsed = JSON.parse(decrypted, symbolize_names: true)
        expect(parsed[:user_id]).to eq(123)
        expect(parsed[:roles]).to eq(['admin', 'user'])
      end
    end

    context 'when KSP is disabled' do
      before do
        described_class.disable
      end

      context 'in non-strict mode' do
        it 'returns original data for encrypt' do
          result = described_class.encrypt('test data')
          expect(result).to eq('test data')
        end

        it 'returns original data for decrypt' do
          result = described_class.decrypt('test data')
          expect(result).to eq('test data')
        end
      end

      context 'in strict mode' do
        before do
          described_class.instance_variable_set(:@strict, true)
        end

        after do
          described_class.instance_variable_set(:@strict, false)
        end

        it 'raises error for encrypt' do
          expect { described_class.encrypt('test data') }.to raise_error(RuntimeError, 'KSP is disabled - cannot encrypt in strict mode')
        end

        it 'raises error for decrypt' do
          expect { described_class.decrypt('test data') }.to raise_error(RuntimeError, 'KSP is disabled - cannot decrypt in strict mode')
        end
      end
    end

    context 'with corrupted encrypted data' do
      before do
        described_class.enable
      end

      it 'handles corrupted base64 data' do
        corrupted_data = 'invalid_base64_data'
        
        expect { described_class.decrypt(corrupted_data) }.not_to raise_error
        # Should return original data in non-strict mode
        result = described_class.decrypt(corrupted_data)
        expect(result).to eq(corrupted_data)
      end

      it 'handles corrupted JSON structure in strict mode' do
        described_class.disable
        described_class.enable(strict: true)
        
        corrupted_json = Base64.strict_encode64('{"invalid": "json"')
        expect { described_class.decrypt(corrupted_json) }.to raise_error(RuntimeError)
      end

      it 'handles tampered encrypted data' do
        original_data = 'test data'
        encrypted = described_class.encrypt(original_data)
        
        # Tamper with the encrypted data
        decoded = JSON.parse(Base64.strict_decode64(encrypted), symbolize_names: true)
        decoded[:data] = Base64.strict_encode64('tampered_data')
        tampered = Base64.strict_encode64(decoded.to_json)
        
        expect { described_class.decrypt(tampered) }.not_to raise_error
        # In non-strict mode, should return original tampered data
        result = described_class.decrypt(tampered)
        expect(result).to eq(tampered)
      end
    end
  end

  describe '.generate_key' do
    it 'generates valid base64 encoded key' do
      key = described_class.generate_key
      expect(key).to be_a(String)
      expect(key.length).to be > 40  # Base64 encoded 32-byte key

      decoded = Base64.strict_decode64(key)
      expect(decoded.bytesize).to eq(32)
    end

    it 'generates different keys on each call' do
      key1 = described_class.generate_key
      key2 = described_class.generate_key
      expect(key1).not_to eq(key2)
    end
  end

  describe '.status' do
    context 'when disabled' do
      it 'returns disabled status' do
        status = described_class.status
        expect(status[:enabled]).to be false
        expect(status[:key_available]).to be false
        expect(status[:key_id]).to eq('default')
        expect(status[:cipher_method]).to eq('aes-256-gcm')
        expect(status[:strict_mode]).to be false
        expect(status[:requirements_met]).to be true
      end
    end

    context 'when enabled' do
      before do
        described_class.enable
      end

      it 'returns enabled status' do
        status = described_class.status
        expect(status[:enabled]).to be true
        expect(status[:key_available]).to be true
        expect(status[:key_id]).not_to eq('default')
        expect(status[:cipher_method]).to eq('aes-256-gcm')
        expect(status[:strict_mode]).to be false
        expect(status[:requirements_met]).to be true
      end
    end
  end

  describe '.quick_setup' do
    it 'performs complete setup and returns status' do
      result = described_class.quick_setup
      
      expect(result[:requirements]).to be_a(Hash)
      expect(result[:requirements][:all_passed]).to be true
      expect(result[:enabled]).to be true
      expect(result[:key_generated]).to be true
      expect(result[:key_existed]).to be false
      expect(result[:key_fingerprint]).to be_a(String)
      expect(result[:status]).to be_a(Hash)
    end

    context 'with existing key' do
      before do
        ENV['KINDE_KSP_KEY'] = described_class.generate_key
      end

      it 'uses existing key' do
        result = described_class.quick_setup
        expect(result[:key_existed]).to be true
        expect(result[:key_generated]).to be false
      end
    end
  end

  describe '.storage_hook' do
    before do
      described_class.enable
    end

    it 'encrypts data for store operation' do
      test_data = 'sensitive data'
      result = described_class.storage_hook('store', test_data)
      expect(result).not_to eq(test_data)
      expect(described_class.decrypt(result)).to eq(test_data)
    end

    it 'decrypts data for retrieve operation' do
      test_data = 'sensitive data'
      encrypted = described_class.encrypt(test_data)
      result = described_class.storage_hook('retrieve', encrypted)
      expect(result).to eq(test_data)
    end

    it 'returns original data for unknown operations' do
      test_data = 'test data'
      result = described_class.storage_hook('unknown', test_data)
      expect(result).to eq(test_data)
    end
  end

  describe '.wrap_storage' do
    let(:mock_storage) do
      double('Storage', 
        set_item: true,
        get_item: 'stored_value',
        remove_item: true,
        clear: true
      )
    end

    before do
      described_class.enable
    end

    it 'returns StorageWrapper instance' do
      wrapper = described_class.wrap_storage(mock_storage)
      expect(wrapper).to be_a(described_class::StorageWrapper)
    end

    it 'wraps storage methods correctly' do
      wrapper = described_class.wrap_storage(mock_storage)
      
      expect(mock_storage).to receive(:set_item).with('key', kind_of(String))
      wrapper.set_item('key', 'value')
      
      allow(mock_storage).to receive(:get_item).with('key', nil).and_return(described_class.encrypt('value'))
      result = wrapper.get_item('key')
      expect(result).to eq('value')
      
      expect(mock_storage).to receive(:remove_item).with('key')
      wrapper.remove_item('key')
      
      expect(mock_storage).to receive(:clear)
      wrapper.clear
    end

    it 'forwards unknown methods to wrapped storage' do
      custom_method_result = 'custom_result'
      allow(mock_storage).to receive(:custom_method).and_return(custom_method_result)
      
      wrapper = described_class.wrap_storage(mock_storage)
      result = wrapper.custom_method
      expect(result).to eq(custom_method_result)
    end
  end

  describe 'system requirements' do
    it 'checks all required dependencies' do
      requirements = described_class.send(:check_requirements)
      
      expect(requirements[:openssl]).to be true
      expect(requirements[:json]).to be true
      expect(requirements[:securerandom]).to be true
      expect(requirements[:base64]).to be true
      expect(requirements[:digest]).to be true
      expect(requirements[:aes_256_gcm]).to be true
      expect(requirements[:all_passed]).to be true
    end
  end

  describe 'encryption payload structure' do
    before do
      described_class.enable
    end

    it 'creates properly structured encrypted payload' do
      test_data = 'test data'
      encrypted = described_class.encrypt(test_data)
      
      decoded = Base64.strict_decode64(encrypted)
      payload = JSON.parse(decoded, symbolize_names: true)
      
      expect(payload).to have_key(:v)
      expect(payload).to have_key(:k)
      expect(payload).to have_key(:iv)
      expect(payload).to have_key(:tag)
      expect(payload).to have_key(:data)
      
      expect(payload[:v]).to eq(1)  # Version
      expect(payload[:k]).to be_a(String)  # Key ID
      expect(payload[:iv]).to be_a(String)  # IV (base64)
      expect(payload[:tag]).to be_a(String)  # Auth tag (base64)
      expect(payload[:data]).to be_a(String)  # Encrypted data (base64)
    end
  end

  describe 'key management' do
    it 'generates consistent key fingerprint for same key' do
      test_key = described_class.generate_key
      
      described_class.enable(key: test_key)
      key_id1 = described_class.key_id
      
      described_class.disable
      described_class.enable(key: test_key)
      key_id2 = described_class.key_id
      
      expect(key_id1).to eq(key_id2)
    end

    it 'generates different key fingerprints for different keys' do
      key1 = described_class.generate_key
      key2 = described_class.generate_key
      
      described_class.enable(key: key1)
      key_id1 = described_class.key_id
      
      described_class.disable
      described_class.enable(key: key2)
      key_id2 = described_class.key_id
      
      expect(key_id1).not_to eq(key_id2)
    end
  end

  describe 'error handling edge cases' do
    before do
      described_class.enable
    end

    it 'handles malformed encrypted data gracefully' do
      malformed_data = 'not_encrypted_data'
      
      # Should not raise in non-strict mode
      result = described_class.decrypt(malformed_data)
      expect(result).to eq(malformed_data)
    end

    it 'validates component lengths during decryption' do
      # Create invalid payload with wrong IV length
      invalid_payload = {
        v: 1,
        k: 'test_key_id',
        iv: Base64.strict_encode64('short_iv'),  # Too short
        tag: Base64.strict_encode64(SecureRandom.random_bytes(16)),
        data: Base64.strict_encode64('test_data')
      }
      
      encrypted_invalid = Base64.strict_encode64(invalid_payload.to_json)
      
      # Should handle gracefully in non-strict mode
      result = described_class.decrypt(encrypted_invalid)
      expect(result).to eq(encrypted_invalid)
    end
  end

  describe 'thread safety' do
    before do
      described_class.enable
    end

    it 'handles concurrent encryption operations' do
      test_data = 'thread_test_data'
      results = []
      
      threads = 10.times.map do |i|
        Thread.new do
          encrypted = described_class.encrypt("#{test_data}_#{i}")
          decrypted = described_class.decrypt(encrypted)
          results << decrypted
        end
      end
      
      threads.each(&:join)
      
      expect(results.length).to eq(10)
      results.each_with_index do |result, i|
        expect(result).to eq("#{test_data}_#{i}")
      end
    end
  end

  describe 'memory safety' do
    before do
      described_class.enable
    end

    it 'does not leak sensitive data in error messages' do
      sensitive_data = 'super_secret_password_123'
      
      # Force an error condition that might expose data
      allow(OpenSSL::Cipher).to receive(:new).and_raise(StandardError.new('cipher error'))
      
      begin
        described_class.encrypt(sensitive_data)
      rescue StandardError => e
        expect(e.message).not_to include(sensitive_data)
      end
    end
  end
end
