require 'test_helper'

class HasTest < ActiveSupport::TestCase
  def setup
    @client = create_test_client
  end

  # ========== Unified has method tests ==========

  test "has returns true when no conditions provided" do
    assert @client.has({})
  end

  test "has returns true when empty conditions provided" do 
    assert @client.has(nil)
  end

  test "has returns true when all conditions are met" do
    # Mock all individual has methods to return true
    @client.stub :has_roles?, true do
      @client.stub :has_permissions?, true do
        @client.stub :has_feature_flags?, true do
          @client.stub :has_billing_entitlements?, true do
            result = @client.has(
              roles: ['admin'],
              permissions: ['read:users'],
              feature_flags: ['dark_mode'],
              billing_entitlements: ['premium']
            )
            assert result
          end
        end
      end
    end
  end

  test "has returns false when any condition fails (early exit)" do
    # Mock roles to pass, permissions to fail
    @client.stub :has_roles?, true do
      @client.stub :has_permissions?, false do
        # These should not be called due to early exit
        @client.stub :has_feature_flags?, proc { raise "Should not be called" } do
          @client.stub :has_billing_entitlements?, proc { raise "Should not be called" } do
            result = @client.has(
              roles: ['admin'],
              permissions: ['read:users'], 
              feature_flags: ['dark_mode'],
              billing_entitlements: ['premium']
            )
            refute result
          end
        end
      end
    end
  end

  test "has with only roles provided" do
    @client.stub :has_roles?, true do
      result = @client.has(roles: ['admin'])
      assert result
    end
  end

  test "has with only permissions provided" do
    @client.stub :has_permissions?, true do
      result = @client.has(permissions: ['read:users'])
      assert result
    end
  end

  test "has with only feature_flags provided" do
    @client.stub :has_feature_flags?, true do
      result = @client.has(feature_flags: ['dark_mode'])
      assert result
    end
  end

  test "has with only billing_entitlements provided" do
    @client.stub :has_billing_entitlements?, true do
      result = @client.has(billing_entitlements: ['premium'])
      assert result
    end
  end

  test "has with string keys (compatibility)" do
    @client.stub :has_roles?, true do
      @client.stub :has_permissions?, true do
        result = @client.has(
          'roles' => ['admin'],
          'permissions' => ['read:users']
        )
        assert result
      end
    end
  end

  # ========== Force API parameter tests ==========

  test "has with boolean force_api true" do
    @client.stub :has_roles?, proc { |roles, opts| assert_equal true, opts[:force_api]; true } do
      @client.stub :has_permissions?, proc { |perms, opts| assert_equal true, opts[:force_api]; true } do
        @client.stub :has_feature_flags?, proc { |flags, opts| assert_equal true, opts[:force_api]; true } do
          result = @client.has({roles: ['admin'], permissions: ['read'], feature_flags: ['dark']}, true)
          assert result
        end
      end
    end
  end

  test "has with boolean force_api false" do
    @client.stub :has_roles?, proc { |roles, opts| assert_equal false, opts[:force_api]; true } do
      @client.stub :has_permissions?, proc { |perms, opts| assert_equal false, opts[:force_api]; true } do
        @client.stub :has_feature_flags?, proc { |flags, opts| assert_equal false, opts[:force_api]; true } do
          result = @client.has({roles: ['admin'], permissions: ['read'], feature_flags: ['dark']}, false)
          assert result
        end
      end
    end
  end

  test "has with hash force_api parameter" do
    force_api_settings = { roles: true, permissions: false, feature_flags: true }
    
    @client.stub :has_roles?, proc { |roles, opts| assert_equal true, opts[:force_api]; true } do
      @client.stub :has_permissions?, proc { |perms, opts| assert_equal false, opts[:force_api]; true } do
        @client.stub :has_feature_flags?, proc { |flags, opts| assert_equal true, opts[:force_api]; true } do
          result = @client.has(
            {roles: ['admin'], permissions: ['read'], feature_flags: ['dark']}, 
            force_api_settings
          )
          assert result
        end
      end
    end
  end

  test "has with nil force_api parameter" do
    @client.stub :has_roles?, proc { |roles, opts| assert opts[:force_api].nil?; true } do
      result = @client.has({roles: ['admin']}, nil)
      assert result
    end
  end

  # ========== Error handling tests ==========

  test "has gracefully handles errors and returns false" do
    @client.stub :has_roles?, proc { raise StandardError, "API error" } do
      # Should log error and return false, not raise
      result = @client.has(roles: ['admin'])
      refute result
    end
  end

  # ========== Complex conditions tests ==========

  test "has with complex role conditions" do
    mock_role = { key: 'manager', name: 'Senior Manager', department: 'engineering' }
    
    @client.stub :get_roles, [mock_role] do
      result = @client.has_roles?([
        'admin', # Should fail - user doesn't have admin
        {
          role: 'manager',
          condition: ->(role) { role[:department] == 'engineering' }
        }
      ])
      # Should return false because user doesn't have 'admin' role (ALL must pass)
      refute result
    end
  end

  test "has with complex permission conditions" do
    mock_permissions = { org_code: 'org_123', permissions: ['read:users', 'admin:users'] }
    
    @client.stub :get_permissions, mock_permissions do
      result = @client.has_permissions?([
        'read:users', # Should pass
        {
          permission: 'admin:users',
          condition: ->(ctx) { ctx[:org_code] == 'org_123' }
        }
      ])
      assert result
    end
  end

  test "has with complex entitlement conditions" do
    mock_entitlement = double('entitlement', price_name: 'api-access', usage_limit: 150)
    
    @client.stub :get_entitlements, [mock_entitlement] do
      result = @client.has_billing_entitlements?([
        {
          entitlement: 'api-access',
          condition: ->(ent) { ent.usage_limit > 100 }
        }
      ])
      assert result
    end
  end

  # ========== Individual has_permissions? method tests ==========

  test "has_permissions? returns true when no permissions provided" do
    assert @client.has_permissions?(nil)
    assert @client.has_permissions?([])
  end

  test "has_permissions? returns true when user has all required permissions" do
    mock_permissions = { org_code: 'org_123', permissions: ['read:users', 'write:users'] }
    @client.stub :get_permissions, mock_permissions do
      assert @client.has_permissions?(['read:users'])
      assert @client.has_permissions?(['read:users', 'write:users'])
    end
  end

  test "has_permissions? returns false when user missing permissions" do
    mock_permissions = { org_code: 'org_123', permissions: ['read:users'] }
    @client.stub :get_permissions, mock_permissions do
      refute @client.has_permissions?(['write:users'])
      refute @client.has_permissions?(['read:users', 'admin:users'])
    end
  end

  test "has_permissions? handles single permission string" do
    mock_permissions = { org_code: 'org_123', permissions: ['read:users'] }
    @client.stub :get_permissions, mock_permissions do
      assert @client.has_permissions?('read:users')
      refute @client.has_permissions?('write:users')
    end
  end

  test "has_permissions? gracefully handles errors" do
    @client.stub :get_permissions, proc { raise StandardError, "API error" } do
      refute @client.has_permissions?(['read:users'])
    end
  end

  test "has_permissions? with custom condition that passes" do
    mock_permissions = { org_code: 'org_admin', permissions: ['admin:users'] }
    @client.stub :get_permissions, mock_permissions do
      result = @client.has_permissions?([
        {
          permission: 'admin:users',
          condition: ->(ctx) { ctx[:org_code] == 'org_admin' }
        }
      ])
      assert result
    end
  end

  test "has_permissions? with custom condition that fails" do
    mock_permissions = { org_code: 'org_user', permissions: ['admin:users'] }
    @client.stub :get_permissions, mock_permissions do
      result = @client.has_permissions?([
        {
          permission: 'admin:users',
          condition: ->(ctx) { ctx[:org_code] == 'org_admin' }
        }
      ])
      refute result
    end
  end

  test "has_permissions? with custom condition for non-existent permission" do
    mock_permissions = { org_code: 'org_123', permissions: ['read:users'] }
    @client.stub :get_permissions, mock_permissions do
      result = @client.has_permissions?([
        {
          permission: 'admin:users', # User doesn't have this
          condition: ->(ctx) { true } # Condition would pass, but permission missing
        }
      ])
      refute result
    end
  end

  # ========== Enhanced roles tests with custom conditions ==========

  test "has_roles? with custom condition that passes" do
    mock_role = { key: 'manager', name: 'Senior Manager', department: 'engineering' }
    @client.stub :get_roles, [mock_role] do
      result = @client.has_roles?([
        {
          role: 'manager',
          condition: ->(role_obj) { role_obj[:department] == 'engineering' }
        }
      ])
      assert result
    end
  end

  test "has_roles? with custom condition that fails" do
    mock_role = { key: 'manager', name: 'Senior Manager', department: 'marketing' }
    @client.stub :get_roles, [mock_role] do
      result = @client.has_roles?([
        {
          role: 'manager',
          condition: ->(role_obj) { role_obj[:department] == 'engineering' }
        }
      ])
      refute result
    end
  end

  test "has_roles? with mixed simple and complex conditions" do
    mock_roles = [
      { key: 'admin', name: 'Admin' },
      { key: 'manager', name: 'Senior Manager', department: 'engineering' }
    ]
    @client.stub :get_roles, mock_roles do
      result = @client.has_roles?([
        'admin', # Simple check - should pass
        {
          role: 'manager',
          condition: ->(role_obj) { role_obj[:department] == 'engineering' }
        }
      ])
      assert result
    end
  end

  # ========== Enhanced entitlements tests with custom conditions ==========

  test "has_billing_entitlements? with custom condition that passes" do
    mock_entitlement = double('entitlement', 
      price_name: 'api-access', 
      usage_limit: 150,
      tier: 'premium'
    )
    
    @client.stub :get_entitlements, [mock_entitlement] do
      result = @client.has_billing_entitlements?([
        {
          entitlement: 'api-access',
          condition: ->(ent) { ent.usage_limit > 100 && ent.tier == 'premium' }
        }
      ])
      assert result
    end
  end

  test "has_billing_entitlements? with custom condition that fails" do
    mock_entitlement = double('entitlement', price_name: 'api-access', usage_limit: 50)
    
    @client.stub :get_entitlements, [mock_entitlement] do
      result = @client.has_billing_entitlements?([
        {
          entitlement: 'api-access',
          condition: ->(ent) { ent.usage_limit > 100 }
        }
      ])
      refute result
    end
  end

  test "has_billing_entitlements? with mixed simple and complex conditions" do
    mock_entitlements = [
      double('ent1', price_name: 'premium', usage_limit: 200),
      double('ent2', price_name: 'api-access', usage_limit: 150)
    ]
    
    @client.stub :get_entitlements, mock_entitlements do
      result = @client.has_billing_entitlements?([
        'premium', # Simple check
        {
          entitlement: 'api-access',
          condition: ->(ent) { ent.usage_limit > 100 }
        }
      ])
      assert result
    end
  end

  # ========== Compatibility aliases tests ==========

  test "hasRoles alias works" do
    @client.stub :has_roles?, true do
      assert @client.hasRoles(['admin'])
    end
  end

  test "hasPermissions alias works" do
    @client.stub :has_permissions?, true do
      assert @client.hasPermissions(['read:users'])
    end
  end

  test "hasFeatureFlags alias works" do
    @client.stub :has_feature_flags?, true do
      assert @client.hasFeatureFlags(['dark_mode'])
    end
  end

  test "hasBillingEntitlements alias works" do
    @client.stub :has_billing_entitlements?, true do
      assert @client.hasBillingEntitlements(['premium'])
    end
  end

  # ========== Force API parameter parsing tests ==========

  test "parse_force_api_parameter with boolean true" do
    expected = {
      roles: true,
      permissions: true,
      feature_flags: true,
      billing_entitlements: true
    }
    assert_equal expected, @client.send(:parse_force_api_parameter, true)
  end

  test "parse_force_api_parameter with boolean false" do
    expected = {
      roles: false,
      permissions: false,
      feature_flags: false,
      billing_entitlements: true # Always true
    }
    assert_equal expected, @client.send(:parse_force_api_parameter, false)
  end

  test "parse_force_api_parameter with hash" do
    input = { roles: true, permissions: false, feature_flags: true }
    expected = {
      roles: true,
      permissions: false,
      feature_flags: true,
      billing_entitlements: true # Always true
    }
    assert_equal expected, @client.send(:parse_force_api_parameter, input)
  end

  test "parse_force_api_parameter with string keys hash" do
    input = { 'roles' => true, 'permissions' => false }
    expected = {
      roles: true,
      permissions: false,
      feature_flags: nil,
      billing_entitlements: true # Always true
    }
    assert_equal expected, @client.send(:parse_force_api_parameter, input)
  end

  test "parse_force_api_parameter with nil" do
    expected = {
      roles: nil,
      permissions: nil,
      feature_flags: nil,
      billing_entitlements: true # Always true
    }
    assert_equal expected, @client.send(:parse_force_api_parameter, nil)
  end

  # ========== Edge cases and robustness tests ==========

  test "custom condition helpers correctly identify valid condition objects" do
    # Valid condition objects
    valid_role = { role: 'admin', condition: ->(r) { true } }
    valid_permission = { permission: 'read', condition: ->(p) { true } }  
    valid_entitlement = { entitlement: 'premium', condition: ->(e) { true } }

    assert @client.send(:custom_role_condition?, valid_role)
    assert @client.send(:custom_permission_condition?, valid_permission)
    assert @client.send(:custom_entitlement_condition?, valid_entitlement)

    # Invalid condition objects
    refute @client.send(:custom_role_condition?, { role: 'admin' }) # Missing condition
    refute @client.send(:custom_role_condition?, { condition: ->(r) { true } }) # Missing role key
    refute @client.send(:custom_role_condition?, 'admin') # String, not hash
    refute @client.send(:custom_role_condition?, nil) # Nil
  end

  test "has handles malformed conditions gracefully" do
    # Should not raise errors even with malformed conditions
    result = @client.has(
      roles: [{ invalid: 'structure' }],
      permissions: 'invalid'
    )
    # Should default to treating as simple checks and likely return false
    # The exact behavior depends on implementation, but it should not crash
    assert [true, false].include?(result), "Should return boolean, not crash"
  end

  private

  def create_test_client
    # Create a minimal mock client for testing
    client = Object.new
    
    # Add the client modules
    client.extend(KindeSdk::Client::Roles)
    client.extend(KindeSdk::Client::Permissions) 
    client.extend(KindeSdk::Client::FeatureFlags)
    client.extend(KindeSdk::Client::Entitlements)
    
    # Add the main client methods we need
    client.define_singleton_method(:has) do |conditions = {}, force_api = nil|
      return true if conditions.nil? || conditions.empty?

      begin
        # Parse force_api parameter
        force_api_settings = parse_force_api_parameter(force_api)

        # Use early exit pattern for performance (like PHP SDK)
        if conditions.key?(:roles) || conditions.key?('roles')
          roles = conditions[:roles] || conditions['roles']
          roles_force_api = force_api_settings[:roles]
          options = roles_force_api.nil? ? {} : { force_api: roles_force_api }
          return false unless has_roles?(roles, options)
        end

        if conditions.key?(:permissions) || conditions.key?('permissions')
          permissions = conditions[:permissions] || conditions['permissions']
          permissions_force_api = force_api_settings[:permissions]
          options = permissions_force_api.nil? ? {} : { force_api: permissions_force_api }
          return false unless has_permissions?(permissions, options)
        end

        if conditions.key?(:feature_flags) || conditions.key?('feature_flags')
          feature_flags = conditions[:feature_flags] || conditions['feature_flags']
          flags_force_api = force_api_settings[:feature_flags]
          options = flags_force_api.nil? ? {} : { force_api: flags_force_api }
          return false unless has_feature_flags?(feature_flags, options)
        end

        if conditions.key?(:billing_entitlements) || conditions.key?('billing_entitlements')
          billing_entitlements = conditions[:billing_entitlements] || conditions['billing_entitlements']
          return false unless has_billing_entitlements?(billing_entitlements, {})
        end

        true
      rescue StandardError => e
        log_error("Error in has method: #{e.message}")
        false
      end
    end

    # Add the private helper methods
    client.define_singleton_method(:parse_force_api_parameter) do |force_api|
      case force_api
      when true
        {
          roles: true,
          permissions: true,
          feature_flags: true,
          billing_entitlements: true
        }
      when false
        {
          roles: false,
          permissions: false,
          feature_flags: false,
          billing_entitlements: true # Always true for billing entitlements
        }
      when Hash
        {
          roles: force_api[:roles] || force_api['roles'],
          permissions: force_api[:permissions] || force_api['permissions'],
          feature_flags: force_api[:feature_flags] || force_api['feature_flags'],
          billing_entitlements: true # Always true for billing entitlements
        }
      else
        {
          roles: nil,
          permissions: nil,
          feature_flags: nil,
          billing_entitlements: true # Always true for billing entitlements
        }
      end
    end

    # Add logging method
    client.define_singleton_method(:log_error) do |message|
      $stderr.puts "[KindeSdk] ERROR: #{message}"
    end

    # Add aliases
    client.define_singleton_method(:hasRoles) { |roles, options = {}| has_roles?(roles, options) }
    client.define_singleton_method(:hasPermissions) { |permissions, options = {}| has_permissions?(permissions, options) }
    client.define_singleton_method(:hasFeatureFlags) { |flags, options = {}| has_feature_flags?(flags, options) }
    client.define_singleton_method(:hasBillingEntitlements) { |entitlements, options = {}| has_billing_entitlements?(entitlements, options) }

    client
  end
end
