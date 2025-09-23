#!/usr/bin/env ruby
# frozen_string_literal: true

# Kinde KSP (Key Storage Provider) Example
# 
# Demonstrates enterprise-grade encryption for the Kinde Ruby SDK.
# 
# Production Setup:
# 1. Set KINDE_KSP_KEY environment variable with a 256-bit base64-encoded key
# 2. Use KindeSdk::KSP.enable with strict mode for production
# 3. Integrate with your existing Kinde SDK implementation

require 'bundler/setup'
require_relative '../lib/kinde_sdk'

puts "Kinde Ruby SDK - KSP Example"
puts "=" * 40

# Step 1: Enable KSP
puts "\nStep 1: Enable KSP"
puts "-" * 20
enabled = KindeSdk::KSP.enable(
  env_var: 'KINDE_KSP_KEY',
  auto_generate: true,
  strict: false
)

if enabled
  puts "KSP enabled successfully"
  
  status = KindeSdk::KSP.status
  puts "\nStatus:"
  status.each do |key, value|
    puts "  #{key}: #{value}"
  end
else
  puts "KSP failed to initialize"
  exit(1)
end

# ============================================================================
# STEP 2: Test encryption - Simple API
# ============================================================================

puts "\n📋 Step 2: Test Encryption"
puts "-" * 20

sensitive_data = {
  "User email" => "user@example.com",
  "Session token" => "abc123def456",
  "JWT token" => '{"sub":"user123","exp":1234567890}',
  "Personal info" => "SSN: 123-45-6789, Phone: +1234567890"
}

sensitive_data.each do |label, data|
  puts "\n🔸 #{label}"
  puts "Original: #{data}"
  
  # Encrypt
  encrypted = KindeSdk::KSP.encrypt(data)
  puts "Encrypted: #{encrypted[0, 60]}..."
  
  # Decrypt
  decrypted = KindeSdk::KSP.decrypt(encrypted)
  success = data == decrypted
  
  puts "Result: #{success ? '✅ SUCCESS' : '❌ FAILED'}"
  puts "Decrypted: #{decrypted}" if success
end

# Step 3: Integration Example
puts "\nStep 3: Integration Example"
puts "-" * 20
puts "Integration with Kinde Ruby SDK:"

puts <<~INTEGRATION
  
  # Enable KSP
  KindeSdk::KSP.enable
  
  # Configure Kinde SDK
  KindeSdk.configure do |config|
    config.domain = 'https://your-domain.kinde.com'
    config.client_id = 'your_client_id'
    config.client_secret = 'your_client_secret'
    config.callback_url = 'http://localhost:3000/auth/callback'
  end
  
  # Use SDK normally - tokens are now encrypted
  auth_url = KindeSdk.auth_url
  
  # Optional: Storage wrapper
  storage = SomeStorageClass.new
  secure_storage = KindeSdk::KSP.wrap_storage(storage)
  
INTEGRATION

# Step 4: Implementation Details
puts "\nStep 4: Implementation Details"
puts "-" * 20
puts <<~DETAILS
  KSP Implementation:
  
  Files added:
     - lib/kinde_sdk/ksp.rb (core encryption engine)
     - lib/kinde_sdk/storage/ (enhanced storage classes)
  
  Features:
     - Zero additional dependencies (uses built-in OpenSSL)
     - AES-256-GCM encryption
     - High performance with minimal overhead
     - Graceful fallbacks for reliability
     - Ruby/Rails conventions
     
DETAILS

# Step 5: Advanced Features
puts "\nStep 5: Advanced Features"
puts "-" * 20

puts "Storage Wrapper Demo:"
class DemoStorage
  def initialize
    @data = {}
  end
  
  def set_item(key, value)
    @data[key] = value
    puts "  Stored: #{key}"
  end
  
  def get_item(key, default = nil)
    value = @data[key] || default
    puts "  Retrieved: #{key}"
    value
  end
  
  def remove_item(key)
    @data.delete(key)
    puts "  Removed: #{key}"
  end
end

demo_storage = DemoStorage.new
secure_storage = KindeSdk::KSP.wrap_storage(demo_storage)

puts "Setting encrypted value:"
secure_storage.set_item("user_token", "sensitive_token_data")

puts "Getting decrypted value:"
retrieved = secure_storage.get_item("user_token")
puts "Final value: #{retrieved}"

# Quick setup demo
puts "\nQuick Setup Demo:"
setup_result = KindeSdk::KSP.quick_setup
puts "Setup result:"
setup_result.each do |key, value|
  next if key == :requirements
  puts "  #{key}: #{value}"
end

puts "\nKSP Demo Complete"
puts "Kinde Ruby SDK now has enterprise-grade encryption."

# Production key generation
puts "\nProduction Key Generation:"
production_key = KindeSdk::KSP.generate_key
puts "Generated key: #{production_key[0, 20]}..."
puts "Set in environment: KINDE_KSP_KEY=#{production_key}"
puts "Production use: KindeSdk::KSP.enable(strict: true)"
