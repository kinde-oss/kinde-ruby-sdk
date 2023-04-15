## Getting Started

```ruby
# Load the gem
require 'kinde_api'

# Setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
  # Configure a proc to get access tokens in lieu of the static access_token configuration
  config.access_token_getter = -> { 'YOUR TOKEN GETTER PROC' } 
end

api_instance = KindeApi::ConnectedAppsApi.new
key_code_ref = 'key_code_ref_example' # String | The unique key code reference of the connected app to authenticate against.
user_id = 'user_id_example' # String | The id of the user that needs to authenticate to the third-party connected app.

begin
  #Get Connected App URL
  result = api_instance.get_connected_app_auth_url(key_code_ref, user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Exception when calling ConnectedAppsApi->get_connected_app_auth_url: #{e}"
end

```

## Documentation for API Endpoints

All URIs are relative to *https://app.kinde.com*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*KindeApi::ConnectedAppsApi* | [**get_connected_app_auth_url**](docs/ConnectedAppsApi.md#get_connected_app_auth_url) | **GET** /api/v1/connected_apps/auth_url | Get Connected App URL
*KindeApi::ConnectedAppsApi* | [**get_connected_app_token**](docs/ConnectedAppsApi.md#get_connected_app_token) | **GET** /api/v1/connected_apps/token | Get Connected App Token
*KindeApi::ConnectedAppsApi* | [**revoke_connected_app_token**](docs/ConnectedAppsApi.md#revoke_connected_app_token) | **POST** /api/v1/connected_apps/revoke | Revoke Connected App Token
*KindeApi::EnvironmentsApi* | [**delete_environement_feature_flag_override**](docs/EnvironmentsApi.md#delete_environement_feature_flag_override) | **DELETE** /api/v1/environment/feature_flags/{feature_flag_key} | Delete environment feature flag override
*KindeApi::EnvironmentsApi* | [**delete_environement_feature_flag_overrides**](docs/EnvironmentsApi.md#delete_environement_feature_flag_overrides) | **DELETE** /api/v1/environment/feature_flags/ | Delete all environment feature flag overrides
*KindeApi::EnvironmentsApi* | [**update_environement_feature_flag_override**](docs/EnvironmentsApi.md#update_environement_feature_flag_override) | **PATCH** /api/v1/environment/feature_flags/{feature_flag_key} | Update environment feature flag override
*KindeApi::FeatureFlagsApi* | [**create_feature_flag**](docs/FeatureFlagsApi.md#create_feature_flag) | **POST** /api/v1/feature_flags | Create a new feature flag
*KindeApi::FeatureFlagsApi* | [**delete_feature_flag**](docs/FeatureFlagsApi.md#delete_feature_flag) | **DELETE** /api/v1/feature_flags/{feature_flag_key} | Delete a feature flag
*KindeApi::FeatureFlagsApi* | [**update_feature_flag**](docs/FeatureFlagsApi.md#update_feature_flag) | **PUT** /api/v1/feature_flags/{feature_flag_key} | Update a feature flag
*KindeApi::OAuthApi* | [**get_user**](docs/OAuthApi.md#get_user) | **GET** /oauth2/user_profile | Returns the details of the currently logged in user
*KindeApi::OAuthApi* | [**get_user_profile_v2**](docs/OAuthApi.md#get_user_profile_v2) | **GET** /oauth2/v2/user_profile | Returns the details of the currently logged in user
*KindeApi::OrganizationsApi* | [**add_organization_users**](docs/OrganizationsApi.md#add_organization_users) | **POST** /api/v1/organization/users | Assign Users to an Organization
*KindeApi::OrganizationsApi* | [**create_organization**](docs/OrganizationsApi.md#create_organization) | **POST** /api/v1/organization | Create Organization
*KindeApi::OrganizationsApi* | [**delete_organization_feature_flag_override**](docs/OrganizationsApi.md#delete_organization_feature_flag_override) | **DELETE** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Delete organization feature flag override
*KindeApi::OrganizationsApi* | [**delete_organization_feature_flag_overrides**](docs/OrganizationsApi.md#delete_organization_feature_flag_overrides) | **DELETE** /api/v1/organizations/{org_code}/feature_flags | Delete all organization feature flag overrides
*KindeApi::OrganizationsApi* | [**get_organization**](docs/OrganizationsApi.md#get_organization) | **GET** /api/v1/organization | Get Organization
*KindeApi::OrganizationsApi* | [**get_organization_users**](docs/OrganizationsApi.md#get_organization_users) | **GET** /api/v1/organization/users | List Organization Users
*KindeApi::OrganizationsApi* | [**get_organizations**](docs/OrganizationsApi.md#get_organizations) | **GET** /api/v1/organizations | List Organizations
*KindeApi::OrganizationsApi* | [**remove_organization_users**](docs/OrganizationsApi.md#remove_organization_users) | **PATCH** /api/v1/organization/users | Remove Users from an Organization
*KindeApi::OrganizationsApi* | [**update_organization_feature_flag_override**](docs/OrganizationsApi.md#update_organization_feature_flag_override) | **PATCH** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Update organization feature flag override
*KindeApi::UsersApi* | [**add_organization_users**](docs/UsersApi.md#add_organization_users) | **POST** /api/v1/organization/users | Assign Users to an Organization
*KindeApi::UsersApi* | [**create_user**](docs/UsersApi.md#create_user) | **POST** /api/v1/user | Create User
*KindeApi::UsersApi* | [**deleteuser**](docs/UsersApi.md#deleteuser) | **DELETE** /api/v1/user | Delete User
*KindeApi::UsersApi* | [**get_organization_users**](docs/UsersApi.md#get_organization_users) | **GET** /api/v1/organization/users | List Organization Users
*KindeApi::UsersApi* | [**get_user_data**](docs/UsersApi.md#get_user_data) | **GET** /api/v1/user | Get User
*KindeApi::UsersApi* | [**get_users**](docs/UsersApi.md#get_users) | **GET** /api/v1/users | List Users
*KindeApi::UsersApi* | [**remove_organization_users**](docs/UsersApi.md#remove_organization_users) | **PATCH** /api/v1/organization/users | Remove Users from an Organization
*KindeApi::UsersApi* | [**update_user**](docs/UsersApi.md#update_user) | **PATCH** /api/v1/user | Update User


## Documentation for Models

 - [KindeApi::AddOrganizationUsersRequest](docs/AddOrganizationUsersRequest.md)
 - [KindeApi::AddOrganizationUsersResponse](docs/AddOrganizationUsersResponse.md)
 - [KindeApi::ApiResult](docs/ApiResult.md)
 - [KindeApi::ConnectedAppsAccessToken](docs/ConnectedAppsAccessToken.md)
 - [KindeApi::ConnectedAppsAuthUrl](docs/ConnectedAppsAuthUrl.md)
 - [KindeApi::CreateOrganizationRequest](docs/CreateOrganizationRequest.md)
 - [KindeApi::CreateUserRequest](docs/CreateUserRequest.md)
 - [KindeApi::CreateUserRequestIdentitiesInner](docs/CreateUserRequestIdentitiesInner.md)
 - [KindeApi::CreateUserRequestIdentitiesInnerDetails](docs/CreateUserRequestIdentitiesInnerDetails.md)
 - [KindeApi::CreateUserRequestProfile](docs/CreateUserRequestProfile.md)
 - [KindeApi::CreateUserResponse](docs/CreateUserResponse.md)
 - [KindeApi::Error](docs/Error.md)
 - [KindeApi::ErrorResponse](docs/ErrorResponse.md)
 - [KindeApi::GetOrganizationsResponse](docs/GetOrganizationsResponse.md)
 - [KindeApi::GetOrganizationsUsersResponse](docs/GetOrganizationsUsersResponse.md)
 - [KindeApi::Organization](docs/Organization.md)
 - [KindeApi::OrganizationUser](docs/OrganizationUser.md)
 - [KindeApi::RemoveOrganizationUsersRequest](docs/RemoveOrganizationUsersRequest.md)
 - [KindeApi::RemoveOrganizationUsersResponse](docs/RemoveOrganizationUsersResponse.md)
 - [KindeApi::SuccessResponse](docs/SuccessResponse.md)
 - [KindeApi::UpdateUserRequest](docs/UpdateUserRequest.md)
 - [KindeApi::User](docs/User.md)
 - [KindeApi::UserIdentity](docs/UserIdentity.md)
 - [KindeApi::UserIdentityResult](docs/UserIdentityResult.md)
 - [KindeApi::UserProfile](docs/UserProfile.md)
 - [KindeApi::UserProfileV2](docs/UserProfileV2.md)
 - [KindeApi::UsersResponse](docs/UsersResponse.md)


## Documentation for Authorization


### kindeBearerAuth

- **Type**: Bearer authentication (JWT)

