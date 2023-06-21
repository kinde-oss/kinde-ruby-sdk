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

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.
urls = ['inner_example'] # Array<String> | Array of callback urls.

begin
  #Add Redirect Callback URLs
  api_instance.add_redirect_callback_urls(app_id, urls)
rescue KindeApi::ApiError => e
  puts "Exception when calling CallbacksApi->add_redirect_callback_urls: #{e}"
end

```

## Documentation for API Endpoints

All URIs are relative to *https://app.kinde.com*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*KindeApi::CallbacksApi* | [**add_redirect_callback_urls**](docs/CallbacksApi.md#add_redirect_callback_urls) | **POST** /api/v1/applications/{app_id}/auth_redirect_urls | Add Redirect Callback URLs
*KindeApi::CallbacksApi* | [**get_callback_urls**](docs/CallbacksApi.md#get_callback_urls) | **GET** /api/v1/applications/{app_id}/auth_redirect_urls | List Callback URLs
*KindeApi::CallbacksApi* | [**replace_redirect_callback_urls**](docs/CallbacksApi.md#replace_redirect_callback_urls) | **PUT** /api/v1/applications/{app_id}/auth_redirect_urls | Replace redirect callback URLs
*KindeApi::ConnectedAppsApi* | [**get_connected_app_auth_url**](docs/ConnectedAppsApi.md#get_connected_app_auth_url) | **GET** /api/v1/connected_apps/auth_url | Get Connected App URL
*KindeApi::ConnectedAppsApi* | [**get_connected_app_token**](docs/ConnectedAppsApi.md#get_connected_app_token) | **GET** /api/v1/connected_apps/token | Get Connected App Token
*KindeApi::ConnectedAppsApi* | [**revoke_connected_app_token**](docs/ConnectedAppsApi.md#revoke_connected_app_token) | **POST** /api/v1/connected_apps/revoke | Revoke Connected App Token
*KindeApi::EnvironmentsApi* | [**delete_environement_feature_flag_override**](docs/EnvironmentsApi.md#delete_environement_feature_flag_override) | **DELETE** /api/v1/environment/feature_flags/{feature_flag_key} | Delete environment feature flag override
*KindeApi::EnvironmentsApi* | [**delete_environement_feature_flag_overrides**](docs/EnvironmentsApi.md#delete_environement_feature_flag_overrides) | **DELETE** /api/v1/environment/feature_flags | Delete all environment feature flag overrides
*KindeApi::EnvironmentsApi* | [**get_environement_feature_flags**](docs/EnvironmentsApi.md#get_environement_feature_flags) | **GET** /api/v1/environment/feature_flags | List environment feature flags
*KindeApi::EnvironmentsApi* | [**update_environement_feature_flag_override**](docs/EnvironmentsApi.md#update_environement_feature_flag_override) | **PATCH** /api/v1/environment/feature_flags/{feature_flag_key} | Update environment feature flag override
*KindeApi::FeatureFlagsApi* | [**create_feature_flag**](docs/FeatureFlagsApi.md#create_feature_flag) | **POST** /api/v1/feature_flags | Create a new feature flag
*KindeApi::FeatureFlagsApi* | [**delete_feature_flag**](docs/FeatureFlagsApi.md#delete_feature_flag) | **DELETE** /api/v1/feature_flags/{feature_flag_key} | Delete a feature flag
*KindeApi::FeatureFlagsApi* | [**update_feature_flag**](docs/FeatureFlagsApi.md#update_feature_flag) | **PUT** /api/v1/feature_flags/{feature_flag_key} | Update a feature flag
*KindeApi::OAuthApi* | [**get_user**](docs/OAuthApi.md#get_user) | **GET** /oauth2/user_profile | Returns the details of the currently logged in user
*KindeApi::OAuthApi* | [**get_user_profile_v2**](docs/OAuthApi.md#get_user_profile_v2) | **GET** /oauth2/v2/user_profile | Returns the details of the currently logged in user
*KindeApi::OrganizationsApi* | [**add_organization_users**](docs/OrganizationsApi.md#add_organization_users) | **POST** /api/v1/organizations/{org_code}/users | Add Organization Users
*KindeApi::OrganizationsApi* | [**create_organization**](docs/OrganizationsApi.md#create_organization) | **POST** /api/v1/organization | Create Organization
*KindeApi::OrganizationsApi* | [**create_organization_user_role**](docs/OrganizationsApi.md#create_organization_user_role) | **POST** /api/v1/organizations/{org_code}/users/{user_id}/roles | Add Organization User Role
*KindeApi::OrganizationsApi* | [**delete_organization_feature_flag_override**](docs/OrganizationsApi.md#delete_organization_feature_flag_override) | **DELETE** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Delete organization feature flag override
*KindeApi::OrganizationsApi* | [**delete_organization_feature_flag_overrides**](docs/OrganizationsApi.md#delete_organization_feature_flag_overrides) | **DELETE** /api/v1/organizations/{org_code}/feature_flags | Delete all organization feature flag overrides
*KindeApi::OrganizationsApi* | [**delete_organization_user_role**](docs/OrganizationsApi.md#delete_organization_user_role) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/roles/{role_id} | Delete Organization User Role
*KindeApi::OrganizationsApi* | [**get_organization**](docs/OrganizationsApi.md#get_organization) | **GET** /api/v1/organization | Get Organization
*KindeApi::OrganizationsApi* | [**get_organization_feature_flags**](docs/OrganizationsApi.md#get_organization_feature_flags) | **GET** /api/v1/organizations/{org_code}/feature_flags | List organization feature flags
*KindeApi::OrganizationsApi* | [**get_organization_user_roles**](docs/OrganizationsApi.md#get_organization_user_roles) | **GET** /api/v1/organizations/{org_code}/users/{user_id}/roles | List Organization User Roles
*KindeApi::OrganizationsApi* | [**get_organization_users**](docs/OrganizationsApi.md#get_organization_users) | **GET** /api/v1/organizations/{org_code}/users | List Organization Users
*KindeApi::OrganizationsApi* | [**get_organizations**](docs/OrganizationsApi.md#get_organizations) | **GET** /api/v1/organizations | List Organizations
*KindeApi::OrganizationsApi* | [**remove_organization_user**](docs/OrganizationsApi.md#remove_organization_user) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id} | Remove Organization User
*KindeApi::OrganizationsApi* | [**update_organization**](docs/OrganizationsApi.md#update_organization) | **PATCH** /api/v1/organization/{org_code} | Update Organization
*KindeApi::OrganizationsApi* | [**update_organization_feature_flag_override**](docs/OrganizationsApi.md#update_organization_feature_flag_override) | **PATCH** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Update organization feature flag override
*KindeApi::OrganizationsApi* | [**update_organization_users**](docs/OrganizationsApi.md#update_organization_users) | **PATCH** /api/v1/organizations/{org_code}/users | Update organization users
*KindeApi::PermissionsApi* | [**create_permission**](docs/PermissionsApi.md#create_permission) | **POST** /api/v1/permissions | Create a new permission
*KindeApi::PermissionsApi* | [**get_permissions**](docs/PermissionsApi.md#get_permissions) | **GET** /api/v1/permissions | List Permissions
*KindeApi::PermissionsApi* | [**update_permissions**](docs/PermissionsApi.md#update_permissions) | **PATCH** /api/v1/permissions/{permission_id} | Update a permission
*KindeApi::RolesApi* | [**create_role**](docs/RolesApi.md#create_role) | **POST** /api/v1/role | Create a new role
*KindeApi::RolesApi* | [**get_roles**](docs/RolesApi.md#get_roles) | **GET** /api/v1/roles | List Roles
*KindeApi::RolesApi* | [**update_roles**](docs/RolesApi.md#update_roles) | **PATCH** /api/v1/roles/{role_id} | Update a role
*KindeApi::SubscribersApi* | [**create_subscriber**](docs/SubscribersApi.md#create_subscriber) | **POST** /api/v1/subscribers | Create a new subscriber
*KindeApi::SubscribersApi* | [**get_subscriber**](docs/SubscribersApi.md#get_subscriber) | **GET** /api/v1/subscribers/{subscriber_id} | Get Subscriber
*KindeApi::SubscribersApi* | [**get_subscribers**](docs/SubscribersApi.md#get_subscribers) | **GET** /api/v1/subscribers | List Subscribers
*KindeApi::UsersApi* | [**create_user**](docs/UsersApi.md#create_user) | **POST** /api/v1/user | Create User
*KindeApi::UsersApi* | [**delete_user**](docs/UsersApi.md#delete_user) | **DELETE** /api/v1/user | Delete User
*KindeApi::UsersApi* | [**get_user_data**](docs/UsersApi.md#get_user_data) | **GET** /api/v1/user | Get User
*KindeApi::UsersApi* | [**get_users**](docs/UsersApi.md#get_users) | **GET** /api/v1/users | List Users
*KindeApi::UsersApi* | [**update_user**](docs/UsersApi.md#update_user) | **PATCH** /api/v1/user | Update User


## Documentation for Models

 - [KindeApi::AddOrganizationUsersRequest](docs/AddOrganizationUsersRequest.md)
 - [KindeApi::AddOrganizationUsersRequestUsersInner](docs/AddOrganizationUsersRequestUsersInner.md)
 - [KindeApi::AddOrganizationUsersResponse](docs/AddOrganizationUsersResponse.md)
 - [KindeApi::ApiResult](docs/ApiResult.md)
 - [KindeApi::Application](docs/Application.md)
 - [KindeApi::ConnectedAppsAccessToken](docs/ConnectedAppsAccessToken.md)
 - [KindeApi::ConnectedAppsAuthUrl](docs/ConnectedAppsAuthUrl.md)
 - [KindeApi::CreateOrganizationRequest](docs/CreateOrganizationRequest.md)
 - [KindeApi::CreateOrganizationResponse](docs/CreateOrganizationResponse.md)
 - [KindeApi::CreateOrganizationResponseOrganization](docs/CreateOrganizationResponseOrganization.md)
 - [KindeApi::CreateOrganizationUserRoleRequest](docs/CreateOrganizationUserRoleRequest.md)
 - [KindeApi::CreatePermissionRequest](docs/CreatePermissionRequest.md)
 - [KindeApi::CreateRoleRequest](docs/CreateRoleRequest.md)
 - [KindeApi::CreateSubscriberSuccessResponse](docs/CreateSubscriberSuccessResponse.md)
 - [KindeApi::CreateSubscriberSuccessResponseSubscriber](docs/CreateSubscriberSuccessResponseSubscriber.md)
 - [KindeApi::CreateUserRequest](docs/CreateUserRequest.md)
 - [KindeApi::CreateUserRequestIdentitiesInner](docs/CreateUserRequestIdentitiesInner.md)
 - [KindeApi::CreateUserRequestIdentitiesInnerDetails](docs/CreateUserRequestIdentitiesInnerDetails.md)
 - [KindeApi::CreateUserRequestProfile](docs/CreateUserRequestProfile.md)
 - [KindeApi::CreateUserResponse](docs/CreateUserResponse.md)
 - [KindeApi::Error](docs/Error.md)
 - [KindeApi::ErrorResponse](docs/ErrorResponse.md)
 - [KindeApi::GetApplicationsResponse](docs/GetApplicationsResponse.md)
 - [KindeApi::GetEnvironmentFeatureFlagsResponse](docs/GetEnvironmentFeatureFlagsResponse.md)
 - [KindeApi::GetOrganizationFeatureFlagsResponse](docs/GetOrganizationFeatureFlagsResponse.md)
 - [KindeApi::GetOrganizationFeatureFlagsResponseFeatureFlagsValue](docs/GetOrganizationFeatureFlagsResponseFeatureFlagsValue.md)
 - [KindeApi::GetOrganizationsResponse](docs/GetOrganizationsResponse.md)
 - [KindeApi::GetOrganizationsUserRolesResponse](docs/GetOrganizationsUserRolesResponse.md)
 - [KindeApi::GetOrganizationsUsersResponse](docs/GetOrganizationsUsersResponse.md)
 - [KindeApi::GetRedirectCallbackUrlsResponse](docs/GetRedirectCallbackUrlsResponse.md)
 - [KindeApi::Organization](docs/Organization.md)
 - [KindeApi::OrganizationUser](docs/OrganizationUser.md)
 - [KindeApi::OrganizationUserRole](docs/OrganizationUserRole.md)
 - [KindeApi::Permissions](docs/Permissions.md)
 - [KindeApi::RedirectCallbackUrls](docs/RedirectCallbackUrls.md)
 - [KindeApi::Roles](docs/Roles.md)
 - [KindeApi::SuccessResponse](docs/SuccessResponse.md)
 - [KindeApi::UpdateOrganizationRequest](docs/UpdateOrganizationRequest.md)
 - [KindeApi::UpdateOrganizationUsersRequest](docs/UpdateOrganizationUsersRequest.md)
 - [KindeApi::UpdateOrganizationUsersRequestUsersInner](docs/UpdateOrganizationUsersRequestUsersInner.md)
 - [KindeApi::UpdateOrganizationUsersResponse](docs/UpdateOrganizationUsersResponse.md)
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

