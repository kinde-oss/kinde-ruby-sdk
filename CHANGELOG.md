# Changelog

All notable changes to the Kinde Ruby SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.7.1] - 2026-01-08

### Security
- **Updated httparty dependency** to address [CVE-2024-22049](https://github.com/jnunemaker/httparty/security/advisories/GHSA-hm5p-x4rq-38w4) (SSRF vulnerability in `base_uri`)

---

## [1.7.0] - 2025-09-09

### Added

#### Entitlements Management
- **New entitlements functionality** with comprehensive user entitlement management
- `get_entitlements()` - Retrieve all user entitlements
- `has_billing_entitlements?()` - Check if user has specific billing entitlements by price names
- `has_entitlements?()` - Check if user has specific feature entitlements by keys
- JavaScript SDK compatible aliases: `hasBillingEntitlements`, `hasEntitlements`
- Full integration with Kinde's entitlements system for feature access control

#### Hard check (Force API) Functionality
- **New `force_api` configuration option** for controlling data retrieval method
- **Soft check mode**: Extract user data from JWT token claims (faster, cached)
- **Hard check mode**: Fetch fresh data from Kinde API (slower, always current)
- **Smart fallback logic**: Automatically uses API when token claims are empty
- **Method-level overrides**: Override global setting for specific method calls
- **Environment variable support**: Configure via `KINDE_FORCE_API` environment variable

#### Enhanced Permissions Management
- `get_permissions()` - Get all user permissions with force_api support
- `get_permission()` - Get specific permission status
- `permission_granted?()` - Check if a specific permission is granted
- `getPermissions()` - PHP SDK compatible alias with hard check
- `getAllPermissions()` - Get all permissions with automatic pagination
- Support for both standard and Hasura-specific permission claims
- Graceful fallback from API to token-based permissions on errors

#### Enhanced Roles Management
- `get_roles()` - Get all user roles with smart fallback logic
- `has_roles?()` - Check if user has specific roles
- `getRoles()` - PHP SDK compatible alias with hard check
- `hasRoles()` - JavaScript SDK compatible alias
- Automatic fallback to API when token claims are empty
- Consistent role data normalization across token and API sources

#### Enhanced Feature Flags
- `get_flags()` - Get all feature flags with force_api support
- `get_flag()` - Get specific feature flag with type support (boolean, string, integer)
- Support for default values when flags are not found
- Backward compatibility with legacy 3-parameter calls
- Graceful fallback from API to token-based flags on errors

#### Comprehensive Logging System
- **Configurable logging** that works with or without Rails
- **Multiple log levels**: error, warning, info, debug
- **Contextual logging** with module-specific prefixes
- **Environment-based debug logging** via `KINDE_DEBUG` environment variable
- **Graceful fallbacks** to STDERR/STDOUT when no logger is available

### Enhanced

#### Backward Compatibility
- **Maintained full backward compatibility** with existing Ruby SDK API
- **Legacy method support**: All existing methods continue to work unchanged
- **Positional argument support**: Legacy 3-parameter method calls still supported
- **Token type flexibility**: Support for both `:access_token` and `:id_token` types

#### Error Handling
- **Comprehensive error handling** with graceful fallbacks
- **API error recovery**: Automatic fallback to token-based data when API calls fail
- **Detailed error logging** for debugging and monitoring
- **User-friendly error messages** with context

#### Performance Optimizations
- **Smart caching**: Use token claims when available to reduce API calls
- **Efficient pagination**: Automatic handling of paginated API responses
- **Conditional API calls**: Only call API when necessary or explicitly requested
- **Optimized data extraction**: Streamlined parsing of API responses

### Fixed

#### Bug Fixes
- **Fixed token claim extraction** for roles, permissions, and feature flags
- **Improved error handling** for malformed or missing token claims
- **Fixed pagination handling** for large datasets
- **Resolved edge cases** in data normalization and field extraction
- **Fixed logging configuration** to work across different Ruby environments
- **Improved API response parsing** for various data formats

#### API Integration
- **Enhanced API endpoint integration** with proper error handling
- **Improved token management** and bearer token validation
- **Fixed data consistency** between token claims and API responses
- **Resolved timing issues** with token refresh and API calls

### Technical Improvements

#### Code Quality
- **Modular architecture**: Separated concerns into dedicated modules (Entitlements, Permissions, Roles, FeatureFlags)
- **Comprehensive documentation**: Added detailed method documentation with examples
- **Type safety**: Improved parameter validation and type checking
- **Test coverage**: Enhanced test suite for new functionality

#### Developer Experience
- **Consistent API design**: Unified interface across all user data methods
- **Flexible configuration**: Multiple ways to configure force_api behavior
- **Rich debugging**: Enhanced logging and error reporting
- **Clear migration path**: Backward compatibility ensures smooth upgrades

### Dependencies
- **Updated dependencies** for improved security and performance
- **Enhanced Rails integration** with better initializer support
- **Improved JWT handling** with better error recovery

---

## [1.6.6] - 2025-06-25

### Fixed
- **Backward compatibility** for `get_user` method that was renamed to `get_user_profile_v2` in 1.6.5
- **Field mapping** between UserProfileV2 and legacy hash format
- **Method aliasing** to maintain existing API contracts

---

*For migration guides and detailed usage examples, see the [README.md](README.md) and [BACKWARD_COMPATIBILITY.md](BACKWARD_COMPATIBILITY.md) files.*
