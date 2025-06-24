# Backward Compatibility

## Version 1.6.6 - Backward Compatibility Release

This version provides backward compatibility for the breaking change introduced in version 1.6.5 where `get_user` was renamed to `get_user_profile_v2`.

### What Changed in 1.6.5

- `client.oauth.get_user` was removed
- `client.oauth.get_user_profile_v2` was introduced
- The return type changed from `UserProfile` to `UserProfileV2`

### What's Fixed in 1.6.6

Both methods are now supported:

```ruby
# Old method (still works)
user = client.oauth.get_user
# Returns: Hash with UserProfile fields

# New method (recommended)
user = client.oauth.get_user_profile_v2
# Returns: KindeApi::UserProfileV2
```

### Field Mapping

The `get_user` method now internally calls `get_user_profile_v2` and maps the fields to a hash:

| UserProfileV2 Field | Hash Key |
|-------------------|----------|
| `id` or `sub` | `:id` |
| `email` | `:preferred_email` |
| `provided_id` | `:provided_id` |
| `family_name` | `:last_name` |
| `given_name` | `:first_name` |
| `picture` | `:picture` |

### Usage Examples

```ruby
# Using the old method (returns hash)
user = client.oauth.get_user
puts user[:id]           # => "user_id"
puts user[:first_name]   # => "John"
puts user[:last_name]    # => "Doe"
puts user[:preferred_email] # => "john@example.com"

# Using the new method (returns UserProfileV2 object)
user = client.oauth.get_user_profile_v2
puts user.id             # => "user_id"
puts user.given_name     # => "John"
puts user.family_name    # => "Doe"
puts user.email          # => "john@example.com"
```

### Migration Guide

**For new code**: Use `get_user_profile_v2` as it provides more complete user information and returns a proper object.

**For existing code**: No changes required - `get_user` will continue to work, but now returns a hash instead of a `UserProfile` object.

### Deprecation Notice

The `get_user` method is provided for backward compatibility and may be removed in a future major version. Consider migrating to `get_user_profile_v2` when convenient. 