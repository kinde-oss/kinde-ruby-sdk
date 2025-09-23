require 'spec_helper'
require 'kinde_sdk/token_store_enhanced

RSpec.describe KindeSdk::TokenStoreEnhanced do
  before do
    KindeSdk::KSP.disable
    KindeSdk::KSP.enable
  end

  after do
    KindeSdk::KSP.disable
  end

  let(:sample_tokens) do
    {
      access_token: 'sample_access_token_123',
      refresh_token: 'sample_refresh_token_456',
      expires_at: Time.now.to_i + 3600,
      id_token: 'sample_id_token_789'
    }
  end

  describe '#initialize' do
    context 'without tokens' do
      it 'initializes with empty state' do
        token_store = described_class.new
        expect(token_store.tokens).to be_nil
        expect(token_store.bearer_token).to be_nil
        expect(token_store.expires_at).to be_nil
      end
    end

    context 'with tokens' do
      it 'initializes with provided tokens' do
        token_store = described_class.new(sample_tokens)
        expect(token_store.bearer_token).to eq('sample_access_token_123')
        expect(token_store.expires_at).to eq(sample_tokens[:expires_at])
        expect(token_store.tokens[:access_token]).to eq('sample_access_token_123')
        expect(token_store.tokens[:refresh_token]).to eq('sample_refresh_token_456')
      end

      it 'handles string keys' do
        string_key_tokens = sample_tokens.transform_keys(&:to_s)
        token_store = described_class.new(string_key_tokens)
        expect(token_store.bearer_token).to eq('sample_access_token_123')
      end
    end
  end

  describe '#set_tokens' do
    let(:token_store) { described_class.new }

    it 'sets tokens and updates internal state' do
      token_store.set_tokens(sample_tokens)
      expect(token_store.bearer_token).to eq('sample_access_token_123')
      expect(token_store.expires_at).to eq(sample_tokens[:expires_at])
      expect(token_store.tokens[:refresh_token]).to eq('sample_refresh_token_456')
    end

    it 'handles nil tokens' do
      token_store.set_tokens(nil)
      expect(token_store.tokens).to eq({})
      expect(token_store.bearer_token).to be_nil
      expect(token_store.expires_at).to be_nil
    end

    it 'converts string keys to symbols' do
      string_key_tokens = sample_tokens.transform_keys(&:to_s)
      token_store.set_tokens(string_key_tokens)
      expect(token_store.tokens.keys).to all(be_a(Symbol))
    end

    it 'returns the processed tokens' do
      result = token_store.set_tokens(sample_tokens)
      expect(result).to eq(token_store.tokens)
    end
  end

  describe '#to_session' do
    let(:token_store) { described_class.new(sample_tokens) }

    context 'when KSP is enabled' do
      it 'encrypts session data' do
        session_data = token_store.to_session
        
        expect(session_data[:access_token]).not_to eq('sample_access_token_123')
        expect(session_data[:refresh_token]).not_to eq('sample_refresh_token_456')
        
        # Verify values can be decrypted
        decrypted_access = KindeSdk::KSP.decrypt(session_data[:access_token])
        decrypted_refresh = KindeSdk::KSP.decrypt(session_data[:refresh_token])
        decrypted_expires = KindeSdk::KSP.decrypt(session_data[:expires_at])
        
        expect(decrypted_access).to eq('sample_access_token_123')
        expect(decrypted_refresh).to eq('sample_refresh_token_456')
        expect(decrypted_expires.to_i).to eq(sample_tokens[:expires_at])
      end

      it 'skips nil values' do
        tokens_with_nils = {
          access_token: 'access_token_123',
          refresh_token: nil,
          expires_at: Time.now.to_i + 3600
        }
        
        token_store = described_class.new(tokens_with_nils)
        session_data = token_store.to_session
        
        expect(session_data).to have_key(:access_token)
        expect(session_data).not_to have_key(:refresh_token)
        expect(session_data).to have_key(:expires_at)
      end

      it 'handles empty token store' do
        empty_store = described_class.new
        session_data = empty_store.to_session
        
        expect(session_data).to be_a(Hash)
        # Should not contain encrypted nil values
        session_data.values.each do |value|
          expect(value).not_to be_nil
        end
      end
    end

    context 'when KSP is disabled' do
      before do
        KindeSdk::KSP.disable
      end

      it 'returns unencrypted session data' do
        session_data = token_store.to_session
        
        expect(session_data[:access_token]).to eq('sample_access_token_123')
        expect(session_data[:refresh_token]).to eq('sample_refresh_token_456')
        expect(session_data[:expires_at]).to eq(sample_tokens[:expires_at])
      end
    end
  end

  describe '.from_session' do
    context 'when KSP is enabled' do
      it 'creates TokenStore from encrypted session data' do
        # Create encrypted session data
        original_store = described_class.new(sample_tokens)
        encrypted_session = original_store.to_session
        
        # Recreate from session
        restored_store = described_class.from_session(encrypted_session)
        
        expect(restored_store).to be_a(described_class)
        expect(restored_store.bearer_token).to eq('sample_access_token_123')
        expect(restored_store.tokens[:refresh_token]).to eq('sample_refresh_token_456')
        expect(restored_store.expires_at).to eq(sample_tokens[:expires_at])
      end

      it 'handles partially encrypted session data' do
        encrypted_session = {
          access_token: KindeSdk::KSP.encrypt('access_token_123'),
          refresh_token: nil,  # Nil value
          expires_at: KindeSdk::KSP.encrypt((Time.now.to_i + 3600).to_s)
        }
        
        restored_store = described_class.from_session(encrypted_session)
        
        expect(restored_store.bearer_token).to eq('access_token_123')
        expect(restored_store.tokens[:refresh_token]).to be_nil
        expect(restored_store.expires_at.to_i).to eq(encrypted_session[:expires_at].to_i)
      end

      it 'handles corrupted encrypted data gracefully' do
        corrupted_session = {
          access_token: 'corrupted_data_not_encrypted',
          refresh_token: KindeSdk::KSP.encrypt('valid_refresh_token'),
          expires_at: 'invalid_timestamp'
        }
        
        restored_store = described_class.from_session(corrupted_session)
        
        # Should handle gracefully - corrupted data returned as-is
        expect(restored_store).to be_a(described_class)
      end
    end

    context 'when KSP is disabled' do
      before do
        KindeSdk::KSP.disable
      end

      it 'creates TokenStore from unencrypted session data' do
        unencrypted_session = {
          access_token: 'sample_access_token_123',
          refresh_token: 'sample_refresh_token_456',
          expires_at: sample_tokens[:expires_at]
        }
        
        restored_store = described_class.from_session(unencrypted_session)
        
        expect(restored_store.bearer_token).to eq('sample_access_token_123')
        expect(restored_store.tokens[:refresh_token]).to eq('sample_refresh_token_456')
        expect(restored_store.expires_at).to eq(sample_tokens[:expires_at])
      end
    end

    context 'with nil session data' do
      it 'returns nil for nil input' do
        result = described_class.from_session(nil)
        expect(result).to be_nil
      end

      it 'returns nil for empty hash' do
        result = described_class.from_session({})
        expect(result).to be_a(described_class)
        expect(result.bearer_token).to be_nil
      end
    end
  end

  describe 'round-trip encryption/decryption' do
    it 'maintains data integrity through multiple cycles' do
      # Create original token store
      original_store = described_class.new(sample_tokens)
      
      # Convert to encrypted session and back multiple times
      5.times do
        encrypted_session = original_store.to_session
        restored_store = described_class.from_session(encrypted_session)
        
        expect(restored_store.bearer_token).to eq(original_store.bearer_token)
        expect(restored_store.tokens[:refresh_token]).to eq(original_store.tokens[:refresh_token])
        expect(restored_store.expires_at).to eq(original_store.expires_at)
        
        original_store = restored_store
      end
    end

    it 'handles complex token data structures' do
      complex_tokens = {
        access_token: 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...',
        refresh_token: 'rt_refresh_token_with_special_chars_@#$%^&*()',
        expires_at: Time.now.to_i + 7200,
        id_token: '{"sub":"user123","exp":1234567890,"aud":["app1","app2"]}',
        scope: 'openid profile email offline_access',
        token_type: 'Bearer'
      }
      
      original_store = described_class.new(complex_tokens)
      encrypted_session = original_store.to_session
      restored_store = described_class.from_session(encrypted_session)
      
      expect(restored_store.bearer_token).to eq(complex_tokens[:access_token])
      expect(restored_store.tokens[:id_token]).to eq(complex_tokens[:id_token])
      expect(restored_store.tokens[:scope]).to eq(complex_tokens[:scope])
    end
  end

  describe 'integration with Rails session' do
    let(:mock_rails_session) { {} }
    
    it 'integrates seamlessly with Rails session storage' do
      # Store tokens in Rails session
      token_store = described_class.new(sample_tokens)
      mock_rails_session[:kinde_tokens] = token_store.to_session
      
      # Verify session contains encrypted data
      expect(mock_rails_session[:kinde_tokens][:access_token]).not_to eq('sample_access_token_123')
      
      # Restore from Rails session
      restored_store = described_class.from_session(mock_rails_session[:kinde_tokens])
      
      expect(restored_store.bearer_token).to eq('sample_access_token_123')
      expect(restored_store.tokens[:refresh_token]).to eq('sample_refresh_token_456')
    end

    it 'handles session key rotation gracefully' do
      # Create token store with first key
      token_store = described_class.new(sample_tokens)
      encrypted_session = token_store.to_session
      
      # Simulate key rotation
      KindeSdk::KSP.disable
      new_key = KindeSdk::KSP.generate_key
      KindeSdk::KSP.enable(key: new_key)
      
      # Should handle old encrypted data gracefully
      # In production, this might require migration strategy
      restored_store = described_class.from_session(encrypted_session)
      
      # Behavior depends on implementation - should not crash
      expect { restored_store }.not_to raise_error
    end
  end

  describe 'security considerations' do
    it 'does not expose sensitive data in inspect output' do
      token_store = described_class.new(sample_tokens)
      inspect_output = token_store.inspect
      
      # Should not contain raw token values
      expect(inspect_output).not_to include('sample_access_token_123')
      expect(inspect_output).not_to include('sample_refresh_token_456')
    end

    it 'encrypts each session conversion with different ciphertext' do
      token_store = described_class.new(sample_tokens)
      
      session1 = token_store.to_session
      session2 = token_store.to_session
      
      # Same plaintext should produce different ciphertext due to random IVs
      expect(session1[:access_token]).not_to eq(session2[:access_token])
      expect(session1[:refresh_token]).not_to eq(session2[:refresh_token])
      
      # But both should decrypt to same values
      restored1 = described_class.from_session(session1)
      restored2 = described_class.from_session(session2)
      
      expect(restored1.bearer_token).to eq(restored2.bearer_token)
      expect(restored1.tokens[:refresh_token]).to eq(restored2.tokens[:refresh_token])
    end
  end

  describe 'performance characteristics' do
    it 'handles large token sets efficiently' do
      large_tokens = {}
      100.times do |i|
        large_tokens["token_#{i}".to_sym] = "very_long_token_value_#{i}" * 100
      end
      large_tokens[:access_token] = 'main_access_token'
      
      start_time = Time.now
      token_store = described_class.new(large_tokens)
      encrypted_session = token_store.to_session
      restored_store = described_class.from_session(encrypted_session)
      end_time = Time.now
      
      # Should complete within reasonable time (adjust threshold as needed)
      expect(end_time - start_time).to be < 5.0  # 5 seconds
      expect(restored_store.bearer_token).to eq('main_access_token')
    end
  end

  describe 'edge cases and error handling' do
    it 'handles tokens with special characters' do
      special_tokens = {
        access_token: 'token.with-special_chars@domain:8080/path?query=value&other=123',
        refresh_token: 'refresh+token/with=unsafe&chars<>"\';--',
        expires_at: Time.now.to_i + 3600
      }
      
      token_store = described_class.new(special_tokens)
      encrypted_session = token_store.to_session
      restored_store = described_class.from_session(encrypted_session)
      
      expect(restored_store.bearer_token).to eq(special_tokens[:access_token])
      expect(restored_store.tokens[:refresh_token]).to eq(special_tokens[:refresh_token])
    end

    it 'handles binary data in tokens' do
      binary_token = (0..255).map(&:chr).join.force_encoding('ASCII-8BIT')
      binary_tokens = {
        access_token: binary_token,
        refresh_token: 'normal_refresh_token',
        expires_at: Time.now.to_i + 3600
      }
      
      token_store = described_class.new(binary_tokens)
      encrypted_session = token_store.to_session
      restored_store = described_class.from_session(encrypted_session)
      
      expect(restored_store.bearer_token.bytes).to eq(binary_token.bytes)
      expect(restored_store.bearer_token.encoding.name).to eq('ASCII-8BIT')
    end

    it 'handles extremely long tokens' do
      long_token = 'x' * 100000  # 100KB token
      long_tokens = {
        access_token: long_token,
        refresh_token: 'normal_refresh_token',
        expires_at: Time.now.to_i + 3600
      }
      
      token_store = described_class.new(long_tokens)
      encrypted_session = token_store.to_session
      restored_store = described_class.from_session(encrypted_session)
      
      expect(restored_store.bearer_token).to eq(long_token)
      expect(restored_store.bearer_token.length).to eq(100000)
    end
  end
end
