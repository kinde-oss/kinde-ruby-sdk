require 'spec_helper'
require 'jwt'

RSpec.describe 'KSP (Kinde Session Persistence) Integration' do
  let(:persistent_token) do
    payload = { 
      'sub' => 'user_123',
      'ksp' => { 'persistence' => true }
    }
    JWT.encode(payload, 'secret', 'HS256')
  end
  
  let(:non_persistent_token) do
    payload = { 
      'sub' => 'user_456',
      'ksp' => { 'persistence' => false }
    }
    JWT.encode(payload, 'secret', 'HS256')
  end
  
  let(:token_without_ksp) do
    payload = { 'sub' => 'user_789' }
    JWT.encode(payload, 'secret', 'HS256')
  end

  describe 'TokenStore KSP handling' do
    context 'with persistent token' do
      let(:tokens) { { access_token: persistent_token, refresh_token: 'refresh_123' } }
      let(:store) { KindeSdk::TokenStore.new(tokens) }
      
      it 'sets persistent to true' do
        expect(store.persistent).to be true
      end
      
      it 'sets cookie expiration to 29 days' do
        expect(store.cookie_expiration).to be_within(60).of(Time.now + 2505600)
      end
      
      it 'includes persistence in session data' do
        session_data = store.to_session
        expect(session_data[:persistent]).to be true
      end
    end
    
    context 'with non-persistent token' do
      let(:tokens) { { access_token: non_persistent_token, refresh_token: 'refresh_456' } }
      let(:store) { KindeSdk::TokenStore.new(tokens) }
      
      it 'sets persistent to false' do
        expect(store.persistent).to be false
      end
      
      it 'sets cookie expiration to nil (session cookie)' do
        expect(store.cookie_expiration).to be_nil
      end
      
      it 'includes persistence in session data' do
        session_data = store.to_session
        expect(session_data[:persistent]).to be false
      end
    end
    
    context 'with token without KSP claim' do
      let(:tokens) { { access_token: token_without_ksp, refresh_token: 'refresh_789' } }
      let(:store) { KindeSdk::TokenStore.new(tokens) }
      
      it 'defaults to persistent (true)' do
        expect(store.persistent).to be true
      end
    end
    
    context 'with malformed token' do
      let(:tokens) { { access_token: 'invalid.jwt.token', refresh_token: 'refresh_bad' } }
      let(:store) { KindeSdk::TokenStore.new(tokens) }
      
      it 'defaults to persistent (true) on error' do
        expect(store.persistent).to be true
      end
    end
  end

  describe 'Session configuration' do
    let(:mock_session) { double('session', options: {}) }
    let(:token_manager) { KindeSdk::TokenManager }
    
    context 'with persistent session' do
      it 'sets expire_after to 29 days' do
        expect(mock_session.options).to receive(:[]=).with(:expire_after, 2505600)
        
        token_manager.send(:apply_session_persistence, true, mock_session)
      end
    end
    
    context 'with non-persistent session' do
      it 'sets expire_after to nil (session cookie)' do
        expect(mock_session.options).to receive(:[]=).with(:expire_after, nil)
        
        token_manager.send(:apply_session_persistence, false, mock_session)
      end
    end
    
    context 'with session that does not support options' do
      let(:basic_session) { {} }
      
      it 'handles gracefully' do
        expect { 
          token_manager.send(:apply_session_persistence, true, basic_session)
        }.not_to raise_error
      end
    end
  end

  describe 'KindeSdk.session_persistent?' do
    context 'with persistent token store' do
      before do
        store = KindeSdk::TokenStore.new({ access_token: persistent_token })
        allow(KindeSdk::Current).to receive(:token_store).and_return(store)
      end
      
      it 'returns true' do
        expect(KindeSdk.session_persistent?).to be true
      end
    end
    
    context 'with non-persistent token store' do
      before do
        store = KindeSdk::TokenStore.new({ access_token: non_persistent_token })
        allow(KindeSdk::Current).to receive(:token_store).and_return(store)
      end
      
      it 'returns false' do
        expect(KindeSdk.session_persistent?).to be false
      end
    end
    
    context 'with no token store' do
      before do
        allow(KindeSdk::Current).to receive(:token_store).and_return(nil)
      end
      
      it 'defaults to true' do
        expect(KindeSdk.session_persistent?).to be true
      end
    end
  end

  describe 'Session restoration from data' do
    let(:persistent_session_data) do
      {
        access_token: persistent_token,
        refresh_token: 'refresh_persistent',
        persistent: true
      }
    end
    
    let(:non_persistent_session_data) do
      {
        'access_token' => non_persistent_token,
        'refresh_token' => 'refresh_non_persistent',
        'persistent' => false
      }
    end
    
    it 'restores persistent state from symbol keys' do
      store = KindeSdk::TokenStore.from_session(persistent_session_data)
      expect(store.persistent).to be true
    end
    
    it 'restores persistent state from string keys' do
      store = KindeSdk::TokenStore.from_session(non_persistent_session_data)
      expect(store.persistent).to be false
    end
    
    it 'derives persistence from token when not in session data' do
      session_data = { access_token: non_persistent_token }
      store = KindeSdk::TokenStore.from_session(session_data)
      expect(store.persistent).to be false
    end
  end

  describe 'Integration with client creation' do
    let(:tokens) { { access_token: non_persistent_token } }
    let(:mock_api_client) { instance_double('KindeApi::ApiClient') }
    let(:mock_client) { instance_double('KindeSdk::Client') }
    let(:mock_session) { double('session', options: {}) }
    let(:mock_token_store) { KindeSdk::TokenStore.new(tokens) }
    
    before do
      allow(KindeSdk).to receive(:api_client).and_return(mock_api_client)
      allow(KindeSdk::Client).to receive(:new).and_return(mock_client)
      allow(KindeSdk::Current).to receive(:token_store).and_return(mock_token_store)
      allow(KindeSdk::Current).to receive(:session).and_return(mock_session)
    end
    
    it 'automatically applies KSP configuration when creating client' do
      expect(mock_session.options).to receive(:[]=).with(:expire_after, nil)
      
      KindeSdk.client(tokens)
    end
  end

  describe 'Constants and values' do
    it 'uses 29 days in seconds (2505600) matching other SDKs' do
      store = KindeSdk::TokenStore.new({ access_token: persistent_token })
      expected_time = Time.now + 2505600
      
      expect(store.cookie_expiration).to be_within(1).of(expected_time)
    end
  end
end
