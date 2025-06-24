#!/usr/bin/env ruby

# Add both SDK and OpenAPI lib directories to the load path
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'kinde_api', 'lib'))
require 'kinde_sdk'

# Configure the SDK with dummy values for testing
KindeSdk.configure do |config|
  config.domain = 'https://test.kinde.com'
  config.client_id = 'test_client_id'
  config.client_secret = 'test_client_secret'
  config.callback_url = 'https://test.com/callback'
end

# Mock tokens for testing
tokens = {
  access_token: 'test_token',
  id_token: 'test_id_token',
  refresh_token: 'test_refresh_token'
}

# Create a client
client = KindeSdk.client(tokens, false)

puts "Testing backward compatibility..."
puts "Client version: #{KindeSdk::VERSION}"

# Test that both methods are available
if client.oauth.respond_to?(:get_user)
  puts "✓ get_user method is available"
  puts "  - Returns: Hash (backward compatibility)"
else
  puts "✗ get_user method is NOT available"
end

if client.oauth.respond_to?(:get_user_profile_v2)
  puts "✓ get_user_profile_v2 method is available"
  puts "  - Returns: KindeApi::UserProfileV2 (recommended)"
else
  puts "✗ get_user_profile_v2 method is NOT available"
end

puts "\nBackward compatibility test completed!"
puts "\nNote: get_user now returns a hash instead of UserProfile object for backward compatibility." 