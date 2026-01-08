#!/usr/bin/env ruby

# Kinde Ruby SDK - Has Functionality Examples
# 
# This file demonstrates the comprehensive authorization checking
# capabilities of the Kinde Ruby SDK.

require_relative '../lib/kinde_sdk'

puts "=== Kinde Ruby SDK - Has Functionality Examples ===\n\n"

# Initialize the Kinde client (example configuration)
# In a real application, these would come from environment variables
client = KindeSdk.setup do |config|
  config.domain = 'https://yourapp.kinde.com'
  config.client_id = 'your-client-id'
  config.client_secret = 'your-client-secret'
  config.redirect_url = 'http://localhost:3000/auth/callback'
end

# For these examples, we assume the user is already authenticated
# In a real app, you'd handle authentication first

begin
  puts "1. Simple Role Check"
  has_admin_role = client.has_roles?(['admin'])
  puts "User has admin role: #{has_admin_role ? 'Yes' : 'No'}"

  puts "\n2. Multiple Role Check"
  has_multiple_roles = client.has_roles?(['admin', 'manager'])
  puts "User has admin AND manager roles: #{has_multiple_roles ? 'Yes' : 'No'}"

  puts "\n3. Permission Check"
  can_edit_and_delete = client.has_permissions?(['canEdit', 'canDelete'])
  puts "User can edit and delete: #{can_edit_and_delete ? 'Yes' : 'No'}"

  puts "\n4. Feature Flag Check"
  has_dark_mode_flags = client.has_feature_flags?([
    'darkMode',
    { flag: 'theme', value: 'dark' }
  ])
  puts "User has dark mode and theme=dark: #{has_dark_mode_flags ? 'Yes' : 'No'}"

  puts "\n5. Billing Entitlements Check"
  has_premium = client.has_billing_entitlements?(['premium'])
  puts "User has premium entitlement: #{has_premium ? 'Yes' : 'No'}"

  puts "\n6. Unified Has Check - Simple"
  has_all_simple = client.has(
    roles: ['admin'],
    permissions: ['canEdit'],
    feature_flags: ['darkMode'],
    billing_entitlements: ['premium']
  )
  puts "User has all specified conditions (simple): #{has_all_simple ? 'Yes' : 'No'}"

  puts "\n7. Unified Has Check - With Force API"
  has_all_with_api = client.has(
    {
      roles: ['admin'],
      permissions: ['canEdit']
    },
    true # Force API calls for fresh data
  )
  puts "User has admin role and canEdit permission (fresh from API): #{has_all_with_api ? 'Yes' : 'No'}"

  puts "\n8. Unified Has Check - Selective Force API"
  has_all_selective = client.has(
    {
      roles: ['admin'],
      permissions: ['canEdit'],
      feature_flags: ['darkMode']
    },
    {
      roles: true,        # Force API for roles
      permissions: false, # Use token for permissions
      feature_flags: true # Force API for feature flags
    }
  )
  puts "User has all conditions (selective API usage): #{has_all_selective ? 'Yes' : 'No'}"

  puts "\n9. Complex Condition Check - Roles with Custom Logic"
  has_senior_manager = client.has_roles?([
    'admin', # Simple string check
    {
      role: 'manager',
      condition: ->(role_obj) {
        # Custom logic: manager must be senior level
        role_obj[:name]&.include?('Senior') || role_obj[:level] == 'senior'
      }
    }
  ])
  puts "User has admin role AND is a senior manager: #{has_senior_manager ? 'Yes' : 'No'}"

  puts "\n10. Complex Condition Check - Permissions with Context"
  has_org_admin = client.has_permissions?([
    'read:users', # Basic permission
    {
      permission: 'admin:users',
      condition: ->(context) {
        # Custom logic: admin permission only valid in admin org
        context[:org_code] == 'org_admin' || context[:org_code]&.start_with?('admin_')
      }
    }
  ])
  puts "User has read:users AND admin:users in admin org: #{has_org_admin ? 'Yes' : 'No'}"

  puts "\n11. Complex Condition Check - Billing Entitlements with Limits"
  has_high_tier_api = client.has_billing_entitlements?([
    'premium', # Basic entitlement
    {
      entitlement: 'api-access',
      condition: ->(entitlement) {
        # Custom logic: API access with high usage limit
        entitlement.usage_limit && entitlement.usage_limit > 1000
      }
    }
  ])
  puts "User has premium AND high-tier API access: #{has_high_tier_api ? 'Yes' : 'No'}"

  puts "\n12. Full Complex Example - Multiple Types with Custom Logic"
  has_everything_complex = client.has(
    roles: [
      'admin',
      {
        role: 'manager',
        condition: ->(role) { role[:department] == 'engineering' }
      }
    ],
    permissions: [
      'read:users',
      {
        permission: 'deploy:production',
        condition: ->(context) { context[:org_code] == 'org_engineering' }
      }
    ],
    feature_flags: [
      'advanced_features',
      { flag: 'deployment_env', value: 'production' }
    ],
    billing_entitlements: [
      {
        entitlement: 'enterprise',
        condition: ->(ent) { ent.tier == 'enterprise' && ent.active? }
      }
    ]
  )
  puts "User meets all complex authorization requirements: #{has_everything_complex ? 'Yes' : 'No'}"

  puts "\n13. PHP SDK Compatible Methods"
  # These methods match the PHP SDK naming convention
  puts "Using PHP-style method names:"
  puts "hasRoles: #{client.hasRoles(['admin']) ? 'Yes' : 'No'}"
  puts "hasPermissions: #{client.hasPermissions(['canEdit']) ? 'Yes' : 'No'}"
  puts "hasFeatureFlags: #{client.hasFeatureFlags(['darkMode']) ? 'Yes' : 'No'}"
  puts "hasBillingEntitlements: #{client.hasBillingEntitlements(['premium']) ? 'Yes' : 'No'}"

  puts "\n14. Single Item Checks"
  puts "Single role check: #{client.has_roles?('admin') ? 'Yes' : 'No'}"
  puts "Single permission check: #{client.has_permissions?('canEdit') ? 'Yes' : 'No'}"
  puts "Single flag check: #{client.has_feature_flags?('darkMode') ? 'Yes' : 'No'}"
  puts "Single entitlement check: #{client.has_billing_entitlements?('premium') ? 'Yes' : 'No'}"

  puts "\n15. Edge Cases - Empty Arrays (should return true)"
  puts "Empty roles check: #{client.has_roles?([]) ? 'Yes' : 'No'}"
  puts "Empty permissions check: #{client.has_permissions?([]) ? 'Yes' : 'No'}"
  puts "Empty flags check: #{client.has_feature_flags?([]) ? 'Yes' : 'No'}"
  puts "Empty entitlements check: #{client.has_billing_entitlements?([]) ? 'Yes' : 'No'}"
  puts "Empty has check: #{client.has({}) ? 'Yes' : 'No'}"

rescue StandardError => e
  puts "Error during authorization checks: #{e.message}"
  puts "This is expected if you're not authenticated or don't have test data"
  puts "\nThe has functionality will gracefully handle errors and return false"
  puts "when authentication fails or API calls encounter issues."
end

puts "\n=== Example Complete ===\n"
puts "Key Features Demonstrated:"
puts "• Simple role, permission, feature flag, and entitlement checks"
puts "• Unified has() method combining multiple authorization types"
puts "• Force API parameter for fresh data vs. token-based checks"
puts "• Complex conditions with custom logic using Ruby blocks"
puts "• Early exit optimization for performance"
puts "• Graceful error handling"
puts "• PHP and JavaScript SDK compatibility"
puts "• Support for both symbol and string keys"
puts "• Empty array handling (no constraints = allowed)"
puts ""
puts "This Ruby implementation matches the high standards and"
puts "comprehensive functionality of the JavaScript and PHP SDKs."
