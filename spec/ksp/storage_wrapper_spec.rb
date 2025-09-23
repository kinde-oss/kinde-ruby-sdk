require 'spec_helper'

RSpec.describe KindeSdk::KSP::StorageWrapper do
  let(:mock_storage) do
    double('MockStorage',
      set_item: true,
      get_item: 'stored_value',
      remove_item: true,
      clear: true
    )
  end

  let(:storage_wrapper) { described_class.new(mock_storage) }

  before do
    KindeSdk::KSP.disable
    KindeSdk::KSP.enable
  end

  after do
    KindeSdk::KSP.disable
  end

  describe '#initialize' do
    it 'stores reference to wrapped storage' do
      wrapper = described_class.new(mock_storage)
      expect(wrapper.instance_variable_get(:@storage)).to eq(mock_storage)
    end
  end

  describe '#set_item' do
    context 'with string values' do
      it 'encrypts string values before storage' do
        test_value = 'sensitive_token_data'
        
        expect(mock_storage).to receive(:set_item) do |key, encrypted_value|
          expect(key).to eq('test_key')
          expect(encrypted_value).not_to eq(test_value)
          expect(KindeSdk::KSP.decrypt(encrypted_value)).to eq(test_value)
        end
        
        storage_wrapper.set_item('test_key', test_value)
      end

      it 'handles empty string values' do
        expect(mock_storage).to receive(:set_item) do |key, encrypted_value|
          expect(KindeSdk::KSP.decrypt(encrypted_value)).to eq('')
        end
        
        storage_wrapper.set_item('empty_key', '')
      end
    end

    context 'with non-string values' do
      it 'passes through non-string values unchanged' do
        hash_value = { user_id: 123, active: true }
        
        expect(mock_storage).to receive(:set_item).with('hash_key', hash_value)
        storage_wrapper.set_item('hash_key', hash_value)
      end

      it 'passes through nil values unchanged' do
        expect(mock_storage).to receive(:set_item).with('nil_key', nil)
        storage_wrapper.set_item('nil_key', nil)
      end

      it 'passes through numeric values unchanged' do
        expect(mock_storage).to receive(:set_item).with('num_key', 12345)
        storage_wrapper.set_item('num_key', 12345)
      end
    end
  end

  describe '#get_item' do
    context 'with encrypted string values' do
      it 'decrypts retrieved string values' do
        test_value = 'sensitive_token_data'
        encrypted_value = KindeSdk::KSP.encrypt(test_value)
        
        allow(mock_storage).to receive(:get_item).with('test_key', nil).and_return(encrypted_value)
        
        result = storage_wrapper.get_item('test_key')
        expect(result).to eq(test_value)
      end

      it 'handles empty encrypted values' do
        encrypted_empty = KindeSdk::KSP.encrypt('')
        
        allow(mock_storage).to receive(:get_item).with('empty_key', nil).and_return(encrypted_empty)
        
        result = storage_wrapper.get_item('empty_key')
        expect(result).to eq('')
      end

      it 'uses default value when key not found' do
        default_value = 'default_token'
        
        allow(mock_storage).to receive(:get_item).with('missing_key', default_value).and_return(default_value)
        
        result = storage_wrapper.get_item('missing_key', default_value)
        expect(result).to eq(default_value)
      end
    end

    context 'with non-string values' do
      it 'passes through non-string values unchanged' do
        hash_value = { user_id: 123, active: true }
        
        allow(mock_storage).to receive(:get_item).with('hash_key', nil).and_return(hash_value)
        
        result = storage_wrapper.get_item('hash_key')
        expect(result).to eq(hash_value)
      end

      it 'handles nil values' do
        allow(mock_storage).to receive(:get_item).with('nil_key', nil).and_return(nil)
        
        result = storage_wrapper.get_item('nil_key')
        expect(result).to be_nil
      end
    end

    context 'when value equals default' do
      it 'does not attempt decryption when value equals default' do
        default_value = 'default_value'
        
        allow(mock_storage).to receive(:get_item).with('key', default_value).and_return(default_value)
        
        # Should not attempt to decrypt since value equals default
        expect(KindeSdk::KSP).not_to receive(:decrypt)
        
        result = storage_wrapper.get_item('key', default_value)
        expect(result).to eq(default_value)
      end
    end
  end

  describe '#remove_item' do
    it 'forwards remove_item to wrapped storage' do
      expect(mock_storage).to receive(:remove_item).with('test_key')
      storage_wrapper.remove_item('test_key')
    end
  end

  describe '#clear' do
    context 'when wrapped storage supports clear' do
      it 'forwards clear to wrapped storage' do
        expect(mock_storage).to receive(:clear)
        storage_wrapper.clear
      end
    end

    context 'when wrapped storage does not support clear' do
      let(:limited_storage) { double('LimitedStorage', set_item: true, get_item: 'value') }
      let(:limited_wrapper) { described_class.new(limited_storage) }

      it 'handles missing clear method gracefully' do
        expect { limited_wrapper.clear }.not_to raise_error
      end
    end
  end

  describe '#method_missing' do
    it 'forwards unknown methods to wrapped storage' do
      custom_result = 'custom_method_result'
      allow(mock_storage).to receive(:custom_method).with('arg1', 'arg2').and_return(custom_result)
      
      result = storage_wrapper.custom_method('arg1', 'arg2')
      expect(result).to eq(custom_result)
    end

    it 'forwards methods with blocks' do
      block_result = 'block_result'
      allow(mock_storage).to receive(:method_with_block) do |&block|
        block.call(block_result)
      end
      
      result = nil
      storage_wrapper.method_with_block { |value| result = value }
      expect(result).to eq(block_result)
    end

    it 'raises NoMethodError for unsupported methods' do
      expect { storage_wrapper.nonexistent_method }.to raise_error(NoMethodError)
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true for methods supported by wrapped storage' do
      allow(mock_storage).to receive(:respond_to?).with(:custom_method, false).and_return(true)
      expect(storage_wrapper.respond_to?(:custom_method)).to be true
    end

    it 'returns false for methods not supported by wrapped storage' do
      allow(mock_storage).to receive(:respond_to?).with(:nonexistent_method, false).and_return(false)
      expect(storage_wrapper.respond_to?(:nonexistent_method)).to be false
    end

    it 'handles include_private parameter' do
      allow(mock_storage).to receive(:respond_to?).with(:private_method, true).and_return(true)
      expect(storage_wrapper.respond_to?(:private_method, true)).to be true
    end
  end

  describe 'integration scenarios' do
    context 'with session-like storage' do
      let(:session_storage) do
        storage_data = {}
        storage = Object.new
        storage.define_singleton_method(:set_item) { |key, value| storage_data[key] = value }
        storage.define_singleton_method(:get_item) { |key, default = nil| storage_data[key] || default }
        storage.define_singleton_method(:remove_item) { |key| storage_data.delete(key) }
        storage.define_singleton_method(:clear) { storage_data.clear }
        storage.define_singleton_method(:[]) { |key| storage_data[key] }
        storage.define_singleton_method(:data) { storage_data }
        storage
      end

      let(:session_wrapper) { described_class.new(session_storage) }

      it 'provides transparent encryption for session data' do
        # Store multiple values
        session_wrapper.set_item('access_token', 'secret_access_token_123')
        session_wrapper.set_item('refresh_token', 'secret_refresh_token_456')
        session_wrapper.set_item('user_id', 'user_789')
        
        # Verify values are encrypted in storage (access raw storage data)
        stored_access = session_storage.data['access_token']
        stored_refresh = session_storage.data['refresh_token'] 
        stored_user = session_storage.data['user_id']
        
        expect(stored_access).not_to eq('secret_access_token_123')
        expect(stored_refresh).not_to eq('secret_refresh_token_456')
        expect(stored_user).not_to eq('user_789')
        
        # Verify values are decrypted when retrieved
        expect(session_wrapper.get_item('access_token')).to eq('secret_access_token_123')
        expect(session_wrapper.get_item('refresh_token')).to eq('secret_refresh_token_456')
        expect(session_wrapper.get_item('user_id')).to eq('user_789')
        
        # Test removal
        session_wrapper.remove_item('refresh_token')
        expect(session_wrapper.get_item('refresh_token')).to be_nil
        
        # Test clear
        session_wrapper.clear
        expect(session_wrapper.get_item('access_token')).to be_nil
        expect(session_wrapper.get_item('user_id')).to be_nil
      end
    end

    context 'when KSP is disabled' do
      before do
        KindeSdk::KSP.disable
      end

      it 'passes through values without encryption' do
        test_value = 'unencrypted_value'
        
        expect(mock_storage).to receive(:set_item).with('key', test_value)
        storage_wrapper.set_item('key', test_value)
        
        allow(mock_storage).to receive(:get_item).with('key', nil).and_return(test_value)
        result = storage_wrapper.get_item('key')
        expect(result).to eq(test_value)
      end
    end

    context 'with binary data' do
      it 'handles binary data correctly' do
        binary_data = (0..255).map(&:chr).join.force_encoding('ASCII-8BIT')
        
        expect(mock_storage).to receive(:set_item) do |key, encrypted_value|
          expect(encrypted_value).not_to eq(binary_data)
          decrypted = KindeSdk::KSP.decrypt(encrypted_value)
          expect(decrypted.bytes).to eq(binary_data.bytes)
          expect(decrypted.encoding.name).to eq('ASCII-8BIT')
        end
        
        storage_wrapper.set_item('binary_key', binary_data)
      end
    end

    context 'with unicode data' do
      it 'preserves unicode data correctly' do
        unicode_data = 'Hello 世界 🌍 مرحبا'
        
        expect(mock_storage).to receive(:set_item) do |key, encrypted_value|
          decrypted = KindeSdk::KSP.decrypt(encrypted_value)
          expect(decrypted).to eq(unicode_data)
          expect(decrypted.encoding).to eq(unicode_data.encoding)
        end
        
        storage_wrapper.set_item('unicode_key', unicode_data)
      end
    end
  end

  describe 'error handling' do
    context 'when encryption fails' do
      it 'handles encryption failures gracefully' do
        allow(KindeSdk::KSP).to receive(:encrypt).and_raise(StandardError.new('encryption failed'))
        
        # Should not raise error, should pass through original value
        expect(mock_storage).to receive(:set_item).with('key', 'value')
        expect { storage_wrapper.set_item('key', 'value') }.not_to raise_error
      end
    end

    context 'when decryption fails' do
      it 'handles decryption failures gracefully' do
        corrupted_value = 'corrupted_encrypted_data'
        allow(mock_storage).to receive(:get_item).with('key', nil).and_return(corrupted_value)
        allow(KindeSdk::KSP).to receive(:decrypt).with(corrupted_value).and_raise(StandardError.new('decryption failed'))
        
        # Should not raise error, should pass through original value
        result = storage_wrapper.get_item('key')
        expect(result).to eq(corrupted_value)
      end
    end
  end
end
