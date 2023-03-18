## Getting Started

```ruby
# Load the gem
require 'kinde_sdk'

# Setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
  # Configure a proc to get access tokens in lieu of the static access_token configuration
  config.access_token_getter = -> { 'YOUR TOKEN GETTER PROC' } 
end

api_instance = KindeSdk::ConnectedAppsApi.new
key_code_ref = 'key_code_ref_example' # String | The unique key code reference of the connected app to authenticate against.
user_id = 56 # Integer | The id of the user that needs to authenticate to the third-party connected app.

begin
  #Get Connected App URL
  result = api_instance.get_connected_app_auth_url(key_code_ref, user_id)
  p result
rescue KindeSdk::ApiError => e
  puts "Exception when calling ConnectedAppsApi->get_connected_app_auth_url: #{e}"
end

```

## Documentation for API Endpoints

All URIs are relative to *https://app.kinde.com*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*KindeSdk::ConnectedAppsApi* | [**get_connected_app_auth_url**](docs/ConnectedAppsApi.md#get_connected_app_auth_url) | **GET** /api/v1/connected_apps/auth_url | Get Connected App URL
*KindeSdk::ConnectedAppsApi* | [**get_connected_app_token**](docs/ConnectedAppsApi.md#get_connected_app_token) | **GET** /api/v1/connected_apps/token | Get Connected App Token
*KindeSdk::ConnectedAppsApi* | [**revoke_connected_app_token**](docs/ConnectedAppsApi.md#revoke_connected_app_token) | **POST** /api/v1/connected_apps/revoke | Revoke Connected App Token
*KindeSdk::OAuthApi* | [**get_user**](docs/OAuthApi.md#get_user) | **GET** /oauth2/user_profile | Returns the details of the currently logged in user
*KindeSdk::OAuthApi* | [**get_user_profile_v2**](docs/OAuthApi.md#get_user_profile_v2) | **GET** /oauth2/v2/user_profile | Returns the details of the currently logged in user
*KindeSdk::OrganizationsApi* | [**add_organization_users**](docs/OrganizationsApi.md#add_organization_users) | **POST** /api/v1/organization/users | Assign Users to an Organization
*KindeSdk::OrganizationsApi* | [**create_organization**](docs/OrganizationsApi.md#create_organization) | **POST** /api/v1/organization | Create Organization
*KindeSdk::OrganizationsApi* | [**get_orgainzations**](docs/OrganizationsApi.md#get_orgainzations) | **GET** /api/v1/organizations | List Organizations
*KindeSdk::OrganizationsApi* | [**get_organization**](docs/OrganizationsApi.md#get_organization) | **GET** /api/v1/organization | Get Organization
*KindeSdk::OrganizationsApi* | [**get_organization_users**](docs/OrganizationsApi.md#get_organization_users) | **GET** /api/v1/organization/users | List Organization Users
*KindeSdk::OrganizationsApi* | [**remove_organization_users**](docs/OrganizationsApi.md#remove_organization_users) | **PATCH** /api/v1/organization/users | Remove Users from an Organization
*KindeSdk::UsersApi* | [**add_organization_users**](docs/UsersApi.md#add_organization_users) | **POST** /api/v1/organization/users | Assign Users to an Organization
*KindeSdk::UsersApi* | [**create_user**](docs/UsersApi.md#create_user) | **POST** /api/v1/user | Create User
*KindeSdk::UsersApi* | [**deleteuser**](docs/UsersApi.md#deleteuser) | **DELETE** /api/v1/user | Delete User
*KindeSdk::UsersApi* | [**get_organization_users**](docs/UsersApi.md#get_organization_users) | **GET** /api/v1/organization/users | List Organization Users
*KindeSdk::UsersApi* | [**get_user**](docs/UsersApi.md#get_user) | **GET** /api/v1/user | Get User
*KindeSdk::UsersApi* | [**get_users**](docs/UsersApi.md#get_users) | **GET** /api/v1/users | List Users
*KindeSdk::UsersApi* | [**remove_organization_users**](docs/UsersApi.md#remove_organization_users) | **PATCH** /api/v1/organization/users | Remove Users from an Organization
*KindeSdk::UsersApi* | [**update_user**](docs/UsersApi.md#update_user) | **PATCH** /api/v1/user | Update User


## Documentation for Models

 - [KindeSdk::AddOrganizationUsers200Response](docs/AddOrganizationUsers200Response.md)
 - [KindeSdk::AddOrganizationUsersRequest](docs/AddOrganizationUsersRequest.md)
 - [KindeSdk::ApiResult](docs/ApiResult.md)
 - [KindeSdk::ConnectedAppsAccessToken](docs/ConnectedAppsAccessToken.md)
 - [KindeSdk::ConnectedAppsAuthUrl](docs/ConnectedAppsAuthUrl.md)
 - [KindeSdk::CreateOrganizationRequest](docs/CreateOrganizationRequest.md)
 - [KindeSdk::CreateUser200Response](docs/CreateUser200Response.md)
 - [KindeSdk::CreateUserRequest](docs/CreateUserRequest.md)
 - [KindeSdk::CreateUserRequestIdentitiesInner](docs/CreateUserRequestIdentitiesInner.md)
 - [KindeSdk::CreateUserRequestIdentitiesInnerDetails](docs/CreateUserRequestIdentitiesInnerDetails.md)
 - [KindeSdk::CreateUserRequestProfile](docs/CreateUserRequestProfile.md)
 - [KindeSdk::Organization](docs/Organization.md)
 - [KindeSdk::OrganizationUser](docs/OrganizationUser.md)
 - [KindeSdk::RemoveOrganizationUsers200Response](docs/RemoveOrganizationUsers200Response.md)
 - [KindeSdk::RemoveOrganizationUsersRequest](docs/RemoveOrganizationUsersRequest.md)
 - [KindeSdk::UpdateUserRequest](docs/UpdateUserRequest.md)
 - [KindeSdk::User](docs/User.md)
 - [KindeSdk::UserIdentity](docs/UserIdentity.md)
 - [KindeSdk::UserIdentityResult](docs/UserIdentityResult.md)
 - [KindeSdk::UserProfile](docs/UserProfile.md)
 - [KindeSdk::UserProfileV2](docs/UserProfileV2.md)


## Documentation for Authorization


### kindeBearerAuth

- **Type**: Bearer authentication (JWT)
